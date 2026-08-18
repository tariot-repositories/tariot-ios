//
//  NodeSlaveDetectionViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import Combine
import Foundation

enum ConfirmingSlaveError: LocalizedError {
    case noEnoughSlaves
    case submitFailed
    
    var errorDescription: String {
        switch self {
        case .noEnoughSlaves:
            return "Jumlah krat tidak sesuai!"
        default:
            return "Ups, terjadi kesalahan!"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .noEnoughSlaves:
            return "Silahkan tunggu hingga semua-nya sudah terdeteksi"
        default:
            return "Silahkan coba lagi dalam beberapa saat"
        }
    }
}


final class NodeSlaveDetectionViewModel: ObservableObject {
    @Published private(set) var slaveCodeList: [SlaveData] = []
    var slaveCodeSet: Set<String> = Set<String>()
    
    @Published var isListening: Bool = false
    @Published private(set) var isConfirmingSlaves: Bool = false
    @Published var isConfirmingSlavesError: Bool = false
    var confirmingSlavesError: ConfirmingSlaveError? = nil
    
    var deliveryOrder: DeliveryOrder
    
    private let repository: MQTTRepository
    private var listenTask: Task<Void, Never>?
    
    private let submitRepository: NodeDetectionRepository = NodeDetectionRepository.shared
    
    private let decoder: JSONDecoder
    
    init(repository: MQTTRepository = MQTTRepository.shared, order: DeliveryOrder) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
        self.repository = repository
        self.deliveryOrder = order
    }
    
    func start() async {
        let base_topic: String = Secrets.masterCode
        while true {
            do {
                try await repository.connect()
                isListening = true
                listenTask = Task {
                    for await message in repository.subscribe(to: "\(base_topic)/+") {
                        print(message.payload)
                        print(message.topic)
                        guard let data = message.payload.data(using: .utf8) else { continue }
                        do {
                            let decodedData = try decoder.decode(SlaveData.self, from: data)
                            if Int64(Date.now.timeIntervalSince1970) - decodedData.secondSinceEpoch < 2 {
                                if slaveCodeSet.contains(decodedData.slaveCode) == false {
                                    slaveCodeSet.insert(decodedData.slaveCode)
                                    slaveCodeList.append(decodedData)
                                }
                            }
                        } catch {
                            print("Failed to decode: \(error.localizedDescription)")
                        }
                    }
                }
                break
            } catch {
                print("MQTT connect failed: \(error)")
                continue
            }
        }
    }
    
    func submitDetectedSlave () async {
        isConfirmingSlaves = true
        
        if slaveCodeList.count != Secrets.slaveCount {
            isConfirmingSlavesError = true
            confirmingSlavesError = .noEnoughSlaves
            isConfirmingSlaves = false
            return
        }
        
        let detectedSlaves: DetectedSlaves = DetectedSlaves(
            deliveryId: deliveryOrder.id, masterCode: Secrets.masterCode, detectedSlaves: slaveCodeList)
        
        let newDeliveryOrder: DeliveryOrder
        
        do {
            newDeliveryOrder = try await submitRepository.submitDetectedSlave(detectedSlaves: detectedSlaves)
            isConfirmingSlaves = false
        } catch {
            isConfirmingSlavesError = true
            confirmingSlavesError = .submitFailed
            isConfirmingSlaves = false
            return
        }
        
        Router.shared.push(.inDelivery(newDeliveryOrder))
    }
    
    func stop() {
        listenTask?.cancel()
        repository.disconnect()
        isListening = false
    }
}

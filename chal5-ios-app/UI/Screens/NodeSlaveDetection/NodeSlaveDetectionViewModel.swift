//
//  NodeSlaveDetectionViewModel.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import Combine
import Foundation

//enum ConfirmingSlaveError: LocalizedError {
//    case noEnoughSlaves
//    case submitFailed
//    
//    var errorDescription: String {
//        switch self {
//        case .noEnoughSlaves:
//            return "Tidak ada pesanan yang bisa diterima"
//        default:
//            return "Ups, terjadi kesalahan!"
//        }
//    }
//    
//    var recoverySuggestion: String {
//        switch self {
//        case .noEnoughSlaves:
//            return "Silahkan tunggu hingga semua-nya sudah terdeteksi"
//        default:
//            return "Silahkan coba lagi dalam beberapa saat"
//        }
//    }
//}


final class NodeSlaveDetectionViewModel: ObservableObject {
    @Published private(set) var slaveCodeList: [SlaveData] = []
    var slaveCodeSet: Set<String> = Set<String>()
    
    @Published var isListening: Bool = false
    
    var deliveryOrder: DeliveryOrder
    
    @Published private(set) var decodeError: String?
    
    private let repository: MQTTRepository
    private var listenTask: Task<Void, Never>?
    
    private let decoder: JSONDecoder
    
    init(repository: MQTTRepository = MQTTRepository.shared, order: DeliveryOrder) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
        self.repository = repository
        self.deliveryOrder = order
    }
    
    func start(base_topic: String) async {
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
                        if Int(Date.now.timeIntervalSince1970) - decodedData.secondSinceEpoch < 2 {
                            if slaveCodeSet.contains(decodedData.slaveCode) == false {
                                slaveCodeSet.insert(decodedData.slaveCode)
                                slaveCodeList.append(decodedData)
                            }
                        }
                    } catch {
                        decodeError = "Failed to decode: \(error.localizedDescription)"
                    }
                }
            }
        } catch {
            print("MQTT connect failed: \(error)")
        }
    }
    
    func submitDetectedSlave () {
        stop()
    }
    
    func stop() {
        listenTask?.cancel()
        repository.disconnect()
        isListening = false
    }
}

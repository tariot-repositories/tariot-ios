//
//  NodeDetectionRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 13/08/26.
//

import Foundation
import CocoaMQTT

struct MQTTIncomingMessage {
    let topic: String
    let payload: String
}

final class MQTTRepository: NSObject {
    static let shared: MQTTRepository = .init(host: Secrets.mqttHost, port: Secrets.mqttPort, username: Secrets.mqttUsername, password: Secrets.mqttPassword)
    
    private var mqtt: CocoaMQTT?
    private var continuation: AsyncStream<MQTTIncomingMessage>.Continuation?
    private var connectContinuation: CheckedContinuation<Void, Error>?

    private let host: String
    private let port: UInt16
    private let username: String
    private let password: String

    init(host: String, port: UInt16, username: String, password: String) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }

    func connect() async throws {
        try await withCheckedThrowingContinuation { continuation in
            let clientID = "ios-\(UUID().uuidString.prefix(8))"
            let client = CocoaMQTT(clientID: clientID, host: host, port: port)
            client.username = username
            client.password = password
            client.enableSSL = true
            client.manuallyEvaluateTrust = false // true hanya untuk broker self-signed/dev
            client.delegate = self

            self.mqtt = client
            self.connectContinuation = continuation
            guard client.connect() else {
                continuation.resume(throwing: MQTTError.disconnected)
                return
            }
        }
    }

    func subscribe(to topicFilter: String) -> AsyncStream<MQTTIncomingMessage> {
        AsyncStream { continuation in
            self.continuation = continuation
            mqtt?.subscribe(topicFilter, qos: .qos1)

            continuation.onTermination = { [weak self] _ in
                self?.mqtt?.unsubscribe(topicFilter)
            }
        }
    }

    func publish(to topic: String, payload: String) {
        mqtt?.publish(topic, withString: payload, qos: .qos1)
    }

    func disconnect() {
        mqtt?.disconnect()
        continuation?.finish()
    }
}

extension MQTTRepository: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            connectContinuation?.resume()
        } else {
            connectContinuation?.resume(throwing: MQTTError.connectionFailed(ack))
        }
        connectContinuation = nil
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        continuation?.yield(
            MQTTIncomingMessage(topic: message.topic, payload: message.string ?? "")
        )
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let pending = connectContinuation {
            pending.resume(throwing: err ?? MQTTError.disconnected)
            connectContinuation = nil
        }
        continuation?.finish()
    }

    // required stubs — tidak dipakai tapi wajib diimplementasi protocol delegate
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {}
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {}
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
}


enum MQTTError: Error {
    case connectionFailed(CocoaMQTTConnAck)
    case disconnected
}

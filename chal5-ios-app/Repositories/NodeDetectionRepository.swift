//
//  NodeDetectionRepository.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//


//import Foundation
//
//final class NodeDetectionRepository {
//    private let baseURL = URL(string: "http://127.0.0.1:8000")!
//    private let session: URLSession
//    private let decoder: JSONDecoder
//    
//    init(session: URLSession = .shared) {
//        self.session = session
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .secondsSince1970
//        self.decoder = decoder
//    }
//    
//    func submitDetectedSlave(detectedSlaves: DetectedSlaves) async throws -> Void {
//        let url = baseURL.appendingPathComponent("detect-slaves/submit-detected-slave")
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONEncoder().encode(detectedSlaves)
//        
//        let (_, response) = try await session.data(for: request)
//        guard let http = response as? HTTPURLResponse else {
//            throw APIError.badResponse
//        }
//        
//    }
//}

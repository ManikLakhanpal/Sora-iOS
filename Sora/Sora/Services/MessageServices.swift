//
//  MessageServices.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

class MessageServices {
    static func sendMessage(_ chat: Chat, completion: @escaping (Result<ChatAPIResponse, Error>) -> Void) {
        guard let url = URL(string: "\(backendURL)/api/chat") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add JWT if available
        if let token = UserDefaults.standard.string(forKey: "jwt") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(chat)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(
                    domain: "API Error",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"]
                )
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ChatAPIResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

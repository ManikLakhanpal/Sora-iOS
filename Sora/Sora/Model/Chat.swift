//
//  Chat.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

struct Chat: Codable {
    var history: [ChatHistory]
    var chat: String
}

struct ChatHistory: Codable {
    var role: String
    var parts: [ChatMessage]
}

struct ChatMessage: Codable {
    var text: String
}

struct ChatAPIResponse: Decodable {
    var text: String
}

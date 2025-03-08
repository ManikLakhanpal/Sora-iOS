//
//  Chat.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

struct Chat: Decodable {
    var history: [ChatHistory?]
    var chat: String
}

struct ChatHistory: Decodable {
    var role: String
    var parts: [ChatMessage]
}

struct ChatMessage: Decodable {
    var text: String
}

//
//  MessageViewModel.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

class MessageViewModel: ObservableObject {
    @Published var history: [ChatHistory] = []
    @Published var chat: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    static let shared = MessageViewModel()
    
    func sendMessage() {
        guard !chat.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Add user message to history
        let userMessage = ChatHistory(
            role: "user",
            parts: [ChatMessage(text: chat)]
        )
        history.append(userMessage)
        
        // Create request body
        let request = Chat(
            history: history,
            chat: chat
        )
        
        MessageServices.sendMessage(request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    // Add AI response
                    let aiMessage = ChatHistory(
                        role: "model",
                        parts: [ChatMessage(text: response.text)]
                    )
                    self?.history.append(aiMessage)
                    self?.chat = ""
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    // Remove failed user message
                    if let last = self?.history.last, last.role == "user" {
                        self?.history.removeLast()
                    }
                }
            }
        }
    }
}

//
//  MessageViewModel.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

class MessageViewModel: ObservableObject {
    @Published var history: [ChatHistory] = []
    @Published var inputMessage: String = ""
    @Published var isLoading: Bool? = nil
    @Published var error: String?
    
    static let shared = MessageViewModel()
    
    func sendMessage() {
        guard !inputMessage.isEmpty else { return }
        
        isLoading = true
        error = nil
        
        // Add user message
        let userMessage = ChatHistory(
            role: "user",
            parts: [ChatMessage(text: inputMessage)]
        )
        history.append(userMessage)
        
        // Create request body
        let request = Chat(
            history: history,
            chat: inputMessage
        )
        
        MessageServices.sendMessage(request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.inputMessage = ""
                
                switch result {
                case .success(let response):
                    let aiMessage = ChatHistory(
                        role: "model",
                        parts: [ChatMessage(text: response.text)]
                    )
                    self?.history.append(aiMessage)
                    
                case .failure(let error):
                    self?.error = error.localizedDescription
                    // Remove failed user message
                    if self?.history.last?.role == "user" {
                        self?.history.removeLast()
                    }
                }
            }
        }
    }
}

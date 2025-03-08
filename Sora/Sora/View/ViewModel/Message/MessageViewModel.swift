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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    static let shared = MessageViewModel()

    func sendMessage() {
        guard !chat.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Add user message to history
        let userMessage = ChatHistory(role: "user", parts: [ChatMessage(text: chat)])
        
        // Prepare the request body
        let requestBody = Chat(history: history, chat: chat)
        history.append(userMessage)
        
        MessageServices.sendMessage(requestBody) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    // Add AI response to history
                    let aiMessage = ChatHistory(role: "model", parts: [ChatMessage(text: response.text)])
                    self?.history.append(aiMessage)
                    self?.chat = "" // Clear input field
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

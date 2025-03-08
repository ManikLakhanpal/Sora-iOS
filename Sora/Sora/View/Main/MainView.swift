//
//  MainView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MessageViewModel.shared
    @State private var newMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.history, id: \.self) { chatHistory in
                                ChatBubble(message: chatHistory)
                                    .id(chatHistory.id)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .onChange(of: viewModel.history.count) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.history.last?.id, anchor: .bottom)
                        }
                    }
                }
                .background(Color(.systemBackground))
                
                // Message Input Box
                HStack(alignment: .bottom, spacing: 12) {
                    TextField("Type a message...", text: $newMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 16)
                        .padding(.vertical, 8)
                        .lineLimit(4)
                        .disabled(viewModel.isLoading)
                    
                    Button(action: sendMessage) {
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(12)
                                .background(Color.blue.opacity(0.7))
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 20))
                                .padding(12)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.trailing, 16)
                    .disabled(newMessage.isEmpty || viewModel.isLoading)
                }
                .background(Color(.systemBackground))
                .overlay(Divider(), alignment: .top)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let userMessage = ChatHistory(role: "user", parts: [ChatMessage(text: newMessage)])
        viewModel.history.append(userMessage)
        viewModel.chat = newMessage
        newMessage = ""
        
        viewModel.sendMessage()
    }
}

struct ChatBubble: View {
    let message: ChatHistory
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == "user" {
                Spacer()
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)
            }
            
            Text(message.parts.first?.text ?? "")
                .padding(12)
                .background(message.role == "user" ? Color.blue : Color.gray.opacity(0.15))
                .foregroundColor(message.role == "user" ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            if message.role != "user" {
                Image(systemName: "sparkles")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.purple)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    MainView()
}

//
//  MainView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MessageViewModel.shared
    @State private var newMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.history, id:\.self) { message in
                                ChatBubble(message: message)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                
                // Input Area
                HStack {
                    TextField("Type a message...", text: $newMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isLoading)
                        .onSubmit(sendMessage)
                    
                    Button(action: sendMessage) {
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(8)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    .disabled(newMessage.isEmpty || viewModel.isLoading)
                }
                .padding()
                .background(.regularMaterial)
                .overlay(Divider(), alignment: .top)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("AI Chat")
        }
    }
    
    private func sendMessage() {
        viewModel.chat = newMessage
        viewModel.sendMessage()
        newMessage = ""
    }
}

struct ChatBubble: View {
    let message: ChatHistory
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
            }
            
            Text(message.parts.first?.text ?? "")
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(message.role == "user" ? .blue : .gray.opacity(0.2))
                .foregroundColor(message.role == "user" ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if message.role != "user" {
                Spacer()
            }
        }
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    MainView()
}

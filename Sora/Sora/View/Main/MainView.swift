//
//  MainView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct MainView: View {
    @State private var messages: [Message] = [
        Message(text: "Hello! How can I assist you today?", isFromUser: false),
        Message(text: "Hi! I need help with SwiftUI.", isFromUser: true)
    ]
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: messages.count) { _ in
                    // Scroll to the bottom when a new message is added
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Message Input Box
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .overlay(Divider(), alignment: .top)
        }
        .navigationTitle("AI Chat")
    }
    
    // Send Message Function
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        // Add user message
        messages.append(Message(text: newMessage, isFromUser: true))
        
        // Simulate AI response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(Message(text: "I'm thinking...", isFromUser: false))
        }
        
        // Clear input
        newMessage = ""
    }
}

// Chat Bubble View
struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            Text(message.text)
                .padding(12)
                .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundColor(message.isFromUser ? .white : .primary)
            
            if !message.isFromUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .transition(.opacity)
    }
}

// Message Model
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}

#Preview {
    MainView()
}

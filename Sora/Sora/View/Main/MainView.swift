//
//  MainView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MessageViewModel.shared
    
    var body: some View {
        
        
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.history.indices, id: \.self) { index in
                            let message = viewModel.history[index]
                            ChatBubble(
                                text: message.parts.first?.text ?? "",
                                isUser: message.role == "user"
                            )
                            .id(index)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.history.count) {
                    withAnimation {
                        proxy.scrollTo(viewModel.history.count - 1, anchor: .bottom)
                    }
                }
                .sensoryFeedback(.success, trigger: viewModel.isLoading == false)
            }
            
            HStack(spacing: 16) {
                HStack {
                    TextField("Message", text: $viewModel.inputMessage)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.sendMessage()
                        }
                        .background(Color.clear)
                        .disabled(viewModel.isLoading == true)
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.gray, lineWidth: 1)
                )
                
                HStack {
                    Button {
                        viewModel.sendMessage()
                    } label: {
                        if viewModel.isLoading == true {
                            ProgressView()
                        } else {
                            Image(systemName: "paperplane.fill")
                        }
                    }
                    .disabled(viewModel.inputMessage.isEmpty)
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            .cornerRadius(10)
            .presentationBackground(.clear)
            .padding()
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .sensoryFeedback(.error, trigger: viewModel.error?.isEmpty == false)
            }
        }
        .presentationBackground(.clear)
        
    }
}

#Preview {
    MainView()
}

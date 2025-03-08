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
                .onChange(of: viewModel.history.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.history.count - 1, anchor: .bottom)
                    }
                }
                .sensoryFeedback(.success, trigger: viewModel.isLoading == false)
            }
            
            HStack {
                TextField("Message", text: $viewModel.inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.done)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                    .disabled(viewModel.isLoading == true)
                
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
            .padding()
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .sensoryFeedback(.error, trigger: viewModel.error?.isEmpty == false)
            }
        }
    }
}

#Preview {
    MainView()
}

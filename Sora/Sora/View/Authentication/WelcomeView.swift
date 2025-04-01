//
//  WelcomeView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var animateGradient = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.3)
                    ]),
                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                    endPoint: animateGradient ? .bottomTrailing : .topTrailing
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                
                VStack {
                    Spacer()
                    
                    // Logo/Icon
                    VStack {
                        Image("Sora")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Properly setting image size
                            .background(Color.white) // Ensures background is white
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous)) // Adds smooth rounded corners
                    }
                    .frame(width: 80, height: 80) // VStack frame
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous)) // Ensures VStack is also rounded
                    
                    
                    Text("Sora")
                        .font(.system(size: 52, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 10)
                    

                    
                    // Subtitle
                    Text("Crafting exceptional digital experiences through innovative design and cutting-edge technology.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: { viewModel.login() }) {
                            HStack {
                                Image("google_icon") // Ensure you have a Google icon asset
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign in with Google")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Footer text
                    HStack {
                        Text("By continuing, you agree to our ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        +
                        Text("Terms of Service ")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        +
                        Text("and ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        +
                        Text("Privacy Policy")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthViewModel.shared)
}

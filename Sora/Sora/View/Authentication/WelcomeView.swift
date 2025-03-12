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
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                    endPoint: animateGradient ? .bottomTrailing : .topTrailing
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
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
                    
                    // Error message if present
                    if let errorMessage = viewModel.networkErrorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                            .padding(.bottom, 20)
                    }
                    
                    // Subtitle
                    Text("Crafting exceptional digital experiences through innovative design and cutting-edge technology.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: LoginView()) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.headline)
                                Text("Log In")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        
                        NavigationLink(destination: RegisterView()) {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                    .font(.headline)
                                Text("Create Account")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 3)
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

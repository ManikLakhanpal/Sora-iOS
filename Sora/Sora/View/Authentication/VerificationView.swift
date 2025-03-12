//
//  otpView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 09/03/25.
//

//
//  VerificationView.swift
//  Sora
//

import SwiftUI

struct VerificationView: View {
    @Binding var otpCode: String
    var onSubmit: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isInputFocused: Bool
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
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
            VStack(spacing: 24) {
                // Header with close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "6B7280"))
                            .padding(8)
                            .background(Color(hex: "F3F4F6"))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                // Icon
                Circle()
                    .fill(Color(hex: "EEF2FF"))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "envelope.badge")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "4F46E5"))
                    )
                    .padding(.top, 20)
                
                // Title and description
                Text("Verification Code")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("We've sent a verification code to your email")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // OTP Input
                VStack(spacing: 12) {
                    TextField("", text: $otpCode)
                        .keyboardType(.numberPad)
                        .font(.system(size: 32, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                        .background(Color(hex: "F9FAFB"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)
                        .focused($isInputFocused)
                        .onAppear {
                            isInputFocused = true
                        }
                    
                    Text("Enter the 6-digit code")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 16)
                
                // Verify Button
                Button(action: {
                    onSubmit()
                    dismiss()
                }) {
                    HStack {
                        Text("Verify")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "4F46E5"), Color(hex: "7C3AED")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "4F46E5").opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 24)
                .disabled(otpCode.isEmpty)
                .padding(.horizontal, 32)
                
                // Resend code option
                Button(action: {
                    // Resend code logic would go here
                }) {
                    Text("Didn't receive a code? Resend")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "4F46E5"))
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .cornerRadius(24)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    VerificationView(otpCode: .constant(""), onSubmit: {})
}


//
//  ForgotPasswordView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 17/03/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var email: String
    var onSubmit: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @FocusState private var isInputFocused: Bool
    @State private var animateGradient = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
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
                Text("Forgot Password")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Please enter your email, we will send you a link to reset your password.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Email Input
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(focusedField == .email ? Color(hex: "4F46E5") : Color(hex: "9CA3AF"))
                            .frame(width: 24)
                        
                        TextField("", text: $email)
                            .placeholder(when: email.isEmpty) {
                                Text("Enter your email").foregroundColor(.secondary)
                            }
                            .focused($focusedField, equals: .email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .submitLabel(.done)
                        
                            .onSubmit {
                                onSubmit()
                            }
                        
                            .textContentType(.emailAddress)
                            .foregroundColor(.primary)
                            .onChange(of: email) {
                                email = String(email.lowercased().trimmingCharacters(in: .whitespaces))
                            }
                    }
                    .padding(12)
                    
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedField == .email ? Color(hex: "4F46E5") : .gray, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Verify Button
                Button(action: {
                    onSubmit()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    dismiss()
                }) {
                    HStack {
                        Text("Send Link")
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
                .disabled(email.isEmpty)
                .padding(.horizontal, 32)
                
                
                Spacer()
            }
            .cornerRadius(24)
            .edgesIgnoringSafeArea(.bottom)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    ForgotPasswordView(email: .constant(""), onSubmit: {})
}

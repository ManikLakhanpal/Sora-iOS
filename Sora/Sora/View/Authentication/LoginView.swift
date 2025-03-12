//
//  LoginView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var email: String = ""
    @State var password: String = ""
    @State var otp: String = ""
    
    @FocusState private var focusedField: Field?
    @State var showOTP: Bool = false
    @State private var animateGradient = false
    
    enum Field: Hashable {
        case email
        case password
    }
    
    var body: some View {
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Logo/App icon
                    Circle()
                        .fill(Color(hex: "4F46E5"))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("S")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                    
                    // Title
                    Text("Welcome Back")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "1F2937"))
                    
                    Text("Sign in to your account")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B7280"))
                        .padding(.bottom, 10)
                    
                    // Error message
                    if let error = self.viewModel.loginErrorMessage {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(8)
                            .padding(.horizontal, 24)
                            .transition(.opacity)
                    }

                    // Input Fields
                    VStack(spacing: 20) {
                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "4B5563"))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(focusedField == .email ? Color(hex: "4F46E5") : Color(hex: "9CA3AF"))
                                    .frame(width: 24)
                                
                                TextField("", text: $email)
                                    .placeholder(when: email.isEmpty) {
                                        Text("Enter your email").foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    .focused($focusedField, equals: .email)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                                    .textContentType(.emailAddress)
                                    .onChange(of: email) {
                                        email = String(email.lowercased().trimmingCharacters(in: .whitespaces))
                                    }
                            }
                            .padding(12)
                            .background(Color(hex: "F9FAFB"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .email ? Color(hex: "4F46E5") : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "4B5563"))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(focusedField == .password ? Color(hex: "4F46E5") : Color(hex: "9CA3AF"))
                                    .frame(width: 24)
                                
                                SecureField("", text: $password)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Enter your password").foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        self.showOTP.toggle()
                                        viewModel.requestOTP(email: email)
                                    }
                                    .textContentType(.password)
                            }
                            .padding(12)
                            .background(Color(hex: "F9FAFB"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .password ? Color(hex: "4F46E5") : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Forgot password
                    Button(action: { self.viewModel.forgotPassword(email: email) }) {
                        Text("Forgot Password?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "4F46E5"))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)

                    // Login Button
                    Button(action: {
                        if email.isEmpty || password.isEmpty {
                            AuthViewModel.shared.loginErrorMessage = "Email and password are required."
                            return
                        }
                        self.showOTP.toggle()
                        viewModel.requestOTP(email: email)
                    }) {
                        HStack {
                            Text("Sign In")
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
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // Sign up prompt
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "6B7280"))
                        
                        Button(action: {
                            // Handle navigation to register view
                            dismiss()
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "4F46E5"))
                        }
                    }
                    .padding(.bottom, 40)
                }
                .frame(minHeight: UIScreen.main.bounds.height - 40)
            }
        }
        .sheet(isPresented: $showOTP) {
            VerificationView(otpCode: $otp, onSubmit: processEmailAndPassword)
        }
    }
    
    func processEmailAndPassword() {
        if email.isEmpty {
            return self.viewModel.loginErrorMessage = "Email is required"
        }
        
        if password.count < 7 {
            return self.viewModel.loginErrorMessage = "Password length isn't correct"
        }
        
        self.viewModel.loginErrorMessage = nil
        self.viewModel.login(email: email, password: password, otp: otp)
    }
}

// Helper extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel.shared)
}

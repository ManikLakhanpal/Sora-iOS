//
//  RegisterView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var otp: String = ""
    
    @FocusState private var focusedField: Field?
    @State var showOTP: Bool = false
    @State private var animateGradient = false
    
    enum Field: Hashable {
        case name
        case username
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
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Sign up to get started")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                    
                    // Error message
                    if let error = self.viewModel.registerErrorMessage {
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
                        // Full Name field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Full Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "4B5563"))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(focusedField == .name ? Color(hex: "4F46E5") : Color(hex: "9CA3AF"))
                                    .frame(width: 24)
                                
                                TextField("", text: $name)
                                    .placeholder(when: name.isEmpty) {
                                        Text("Enter your full name").foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    .focused($focusedField, equals: .name)
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .username
                                    }
                                    .textContentType(.name)
                            }
                            .padding(12)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .name ? Color(hex: "4F46E5") : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Username field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Username")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "4B5563"))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "at")
                                    .foregroundColor(focusedField == .username ? Color(hex: "4F46E5") : Color(hex: "9CA3AF"))
                                    .frame(width: 24)
                                
                                TextField("", text: $username)
                                    .placeholder(when: username.isEmpty) {
                                        Text("Choose a username").foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    .focused($focusedField, equals: .username)
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .email
                                    }
                                    .textContentType(.username)
                                    .onChange(of: username) {
                                        username = String(username.lowercased().prefix(16))
                                    }
                            }
                            .padding(12)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .username ? Color(hex: "4F46E5") : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
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
                                        Text("Create a password").foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        self.showOTP.toggle()
                                        viewModel.requestOTP(email: email)
                                    }
                                    .textContentType(.newPassword)
                            }
                            .padding(12)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .password ? Color(hex: "4F46E5") : Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                    }

                    // Register Button
                    Button(action: {
                        if email.isEmpty || password.isEmpty || name.isEmpty || username.isEmpty {
                            AuthViewModel.shared.registerErrorMessage = "Please fill all the fields"
                            return
                        }
                        self.showOTP.toggle()
                        viewModel.requestOTP(email: email)
                    }) {
                        HStack {
                            Text("Create Account")
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
                    
                    // Sign in prompt
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "6B7280"))
                        
                        Button(action: {
                            // Handle navigation to login view
                            dismiss()
                        }) {
                            Text("Sign In")
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
            return self.viewModel.registerErrorMessage = "Email is required"
        }
        
        if name.isEmpty {
            return self.viewModel.registerErrorMessage = "Name is required"
        }
        
        if username.isEmpty {
            return self.viewModel.registerErrorMessage = "Username is required"
        }
        
        if password.count < 7 {
            return self.viewModel.registerErrorMessage = "Password length isn't correct"
        }
        
        self.viewModel.registerErrorMessage = nil
        self.viewModel.register(name: name, username: username, email: email, password: password, otp: otp)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel.shared)
}


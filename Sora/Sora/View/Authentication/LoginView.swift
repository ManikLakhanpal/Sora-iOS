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
    
    @State var email: String = ""
    @State var password: String = ""
    @State var otp: String = ""
    
    @FocusState private var focusedField: Field?
    @State var showOTP: Bool = false
    
    enum Field: Hashable {
        case email
        case password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Title
            Text("Login to Your Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            if let error = self.viewModel.loginErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            // Input Fields
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    .overlay(focusedField == .email ? borderSelectionOverlay : nil)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done) // Shows "Done" on keyboard
                    .onSubmit {
                        self.showOTP.toggle()
                        viewModel.requestOTP(email: email)
                    }
                    .textContentType(.password)
                    .overlay(focusedField == .password ? borderSelectionOverlay : nil)
                    .padding(.horizontal)
            }
            .padding(.top, 10)

            // Register Button
            Button(action: {
                if email.isEmpty || password.isEmpty {
                    AuthViewModel.shared.loginErrorMessage = "Email and password are required."
                    return
                }
                self.showOTP.toggle()
                viewModel.requestOTP(email: email)
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)

            Spacer()
        }
        .sheet(isPresented: $showOTP) {
            VerificationView(otpCode: $otp, onSubmit: processEmailAndPassword)
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
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
    
    private var borderSelectionOverlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel.shared)
}

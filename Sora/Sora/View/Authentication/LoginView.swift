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
    @FocusState private var focusedField: Field?
    
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
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done) // Shows "Done" on keyboard
                    .onSubmit {
                        processEmailAndPassword()
                    }
                    .padding(.horizontal)
            }
            .padding(.top, 10)

            // Register Button
            Button(action: {
                processEmailAndPassword()
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
        self.viewModel.login(email: email, password: password)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel.shared)
}

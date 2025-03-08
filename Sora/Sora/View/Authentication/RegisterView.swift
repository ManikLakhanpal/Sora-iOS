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
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name
        case username
        case email
        case password
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Title
            Text("Create an Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            if let error = self.viewModel.registerErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            // Input Fields
            VStack(spacing: 16) {
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .username
                    }
                    .focused($focusedField, equals: .name)
                    .overlay(focusedField == .name ? borderSelectionOverlay : nil)
                    .padding(.horizontal)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .username)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .email
                    }
                    .onChange(of: username) {
                        username = String(username.lowercased().prefix(16))
                    }
                    .overlay(focusedField == .username ? borderSelectionOverlay : nil)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next) // Shows "Done" on keyboard
                    .onSubmit {
                        focusedField = .password
                    }
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
                        processEmailAndPassword()
                    }
                    .overlay(focusedField == .password ? borderSelectionOverlay : nil)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
            
            // Register Button
            Button(action: {
                self.viewModel.register(name: name, username: username, email: email, password: password)
            }) {
                Text("Register")
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
        self.viewModel.register(name: name, username: username, email: email, password: password)
    }
    
    private var borderSelectionOverlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 2)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel.shared)
}

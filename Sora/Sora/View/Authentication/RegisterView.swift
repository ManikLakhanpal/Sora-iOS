//
//  RegisterView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Title
            Text("Create an Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            // Input Fields
            VStack(spacing: 16) {
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.top, 10)

            // Register Button
            Button(action: {
                // Handle registration logic here
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
}

#Preview {
    RegisterView()
}

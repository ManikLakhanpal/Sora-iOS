//
//  AuthViewModel.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var loginErrorMessage: String?
    @Published var networkErrorMessage: String?
    
    static let shared = AuthViewModel()
    
    func login() {
        Task {
            do {
                try await AuthServices.googleOauth()
            } catch {
                DispatchQueue.main.async {
                    self.loginErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        Task {
            do {
                try await AuthServices().logout()
            } catch {
                DispatchQueue.main.async {
                    self.loginErrorMessage = error.localizedDescription
                }
            }
        }
    }
}

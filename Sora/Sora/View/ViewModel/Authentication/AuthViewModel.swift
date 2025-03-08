//
//  AuthViewModel.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var loginErrorMessage: String?
    
    static let shared = AuthViewModel()
    
    
    init() {
        let token = UserDefaults.standard.string(forKey: "jwt")
        
        if token != nil {
            if let userId = UserDefaults.standard.string(forKey: "userid") {
                fetchUser(userId: userId )
                print("Fetched User : \(currentUser)")
            }
        }
    }
    
    
    func register(name: String, username: String, email: String, password: String) {
        AuthServices.register(email: email, username: username, password: password, name: name) { result in
            
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(ApiResponse.self, from: data!) else { return }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(response.token, forKey: "jwt")
                    UserDefaults.standard.set(response.user.id, forKey: "userid")
                    self.isAuthenticated = true
                    self.currentUser = response.user
                    print("User created and logged \(response.user)")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func login(email: String, password: String) {
        AuthServices.login(email: email, password: password) { result in
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(ApiResponse.self, from: data!) else { return }
                print(response)
                DispatchQueue.main.async {
                    UserDefaults.standard.set(response.token, forKey: "jwt")
                    UserDefaults.standard.set(response.user.id, forKey: "userid")
                    self.isAuthenticated = true
                    self.currentUser = response.user
                    print("User logged in \(response.user)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .custom(let errorMessage):
                        self.loginErrorMessage = errorMessage
                    default:
                        self.loginErrorMessage = "Invalid email or password"
                    }
                }
            }
        }
    }
    
    
    func logout() {
        AuthServices.makePathRequestWithAuth(urlString: URL(string:("\(backendURL)/user/logout"))!, reqBody: nil) { result in
            switch result {
                
            case .success:
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                
                defaults.removeObject(forKey: "jwt")
                defaults.removeObject(forKey: "userid")
                
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    func fetchUser(userId: String) {
        AuthServices.fetchUser(id: userId) { result in
            
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data!) else { return }
                DispatchQueue.main.async {
                    UserDefaults.standard.set(user.id, forKey: "userid")
                    self.isAuthenticated = true
                    self.currentUser = user
                }
                
            case .failure(let error):
                self.isAuthenticated = false
                self.currentUser = nil
                print(error.localizedDescription)
            }
            
        }
    }
}

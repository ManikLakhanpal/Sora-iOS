//
//  AuthServices.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import Foundation
import SwiftUI

public class AuthServices {
    
    static func login(email: String, password: String, otp: String, completion: @escaping (_ result: Result<Data?, AuthenticationError>) -> Void) {
        let urlString = URL(string: "\(backendURL)/user/login")!
        
        makeRequest(urlString: urlString, reqBody: ["email": email, "password": password, "otp": otp]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let networkError):
                switch networkError {
                case .serverError(let message):
                    completion(.failure(.custom(errorMessage: message)))
                    
                default:
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    static func register(email: String, username: String, password: String, name: String, otp: String, completion: @escaping (_ result: Result<Data?, AuthenticationError>) -> Void) {
        let urlString = URL(string: "\(backendURL)/user/signup")!
        
        makeRequest(urlString: urlString, reqBody: ["email": email, "username": username, "password": password, "name": name, "otp": otp]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let networkError):
                switch networkError {
                case .serverError(let message):
                    completion(.failure(.custom(errorMessage: message)))
                    
                default:
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    static func requestOTP(email: String, completion: @escaping (_ result: Result<Data?, AuthenticationError>) -> Void) {
        let urlString = URL(string: "\(backendURL)/user/send-otp")!
        
        makeRequest(urlString: urlString, reqBody: ["email": email]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let networkError):
                switch networkError {
                case .serverError(let message):
                    completion(.failure(.custom(errorMessage: message)))
                    
                default:
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    static func forgotPassword(email: String, completion: @escaping (_ result: Result<Data?, AuthenticationError>) -> Void) {
        let urlString = URL(string: "\(backendURL)/user/forgot-password")!
        
        makeRequest(urlString: urlString, reqBody: ["email": email]) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    AuthViewModel.shared.networkErrorMessage = nil
                    completion(.success(data))
                }
                
            case .failure(let networkError):
                switch networkError {
                case .serverError(let message):
                    completion(.failure(.custom(errorMessage: message)))
                    
                default:
                    AuthViewModel.shared.networkErrorMessage = "It seems that server is down or network is down."
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    static func makeRequest(urlString: URL, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, NetworkError>) -> Void)  {
        let session = URLSession.shared
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted)
        } catch {
            completion(.failure(.invalidURL))
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.invalidURL))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidURL))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = json["error"] as? String {
                        completion(.failure(.serverError(message: errorMessage)))
                    } else {
                        completion(.failure(.decodingError))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    // Fetch the user
    
    static func fetchUser(id: String, completion: @escaping (_ result: Result<Data?, AuthenticationError>) -> Void) {
        
        let urlString = URL(string: "\(backendURL)/user/\(id)")!
        
        var urlRequest = URLRequest(url: urlString)
        
        let session = URLSession.shared
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest) { data, res, err in
            
            guard err == nil else {
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(data))
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                }

            } catch let error {
                completion(.failure(.invalidCredentials))
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    
    static func makePathRequestWithAuth(urlString: URL, reqBody: [String : Any]?, completion: @escaping (_ result: Result<Data?, NetworkError>) -> Void) {
        
        let session = URLSession.shared
        
        var request = URLRequest(url: urlString)
        
        request.httpMethod = "PATCH"
        
        if reqBody != nil {
            do {
            
                request.httpBody = try JSONSerialization.data(withJSONObject: reqBody!, options: .prettyPrinted)
                
            }
            catch let error{
                
                completion(.failure(.noData))
                
            }
        }
        
        let token = UserDefaults.standard.string(forKey: "jwt")!
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, res, err in
        
            guard err == nil else {
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                }

            } catch {
                completion(.failure(.decodingError))
                print(error)
            }
            
        }
        
        task.resume()
    }
}

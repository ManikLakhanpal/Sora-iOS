//
//  NetworkError.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(message: String)
}



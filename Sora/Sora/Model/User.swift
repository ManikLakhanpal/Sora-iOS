//
//  User.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import Foundation

struct User: Decodable, Identifiable {
    let _id: String
    var id: String {
        return _id
    }
    let name: String
    let username: String
    let email: String
}

struct ApiResponse: Decodable {
    let user: User
    let token: String
}

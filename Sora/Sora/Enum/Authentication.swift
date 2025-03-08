//
//  Network.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

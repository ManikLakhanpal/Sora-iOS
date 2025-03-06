//
//  SoraApp.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

let backendURL = "http://localhost:5000"

@main
struct SoraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
        }
    }
}

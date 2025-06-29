//
//  SoraApp.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

let backendURL = "https://sora-backend.w16manik.ninja"

@main
struct SoraApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .environmentObject(AuthViewModel.shared)
        }
    }
}

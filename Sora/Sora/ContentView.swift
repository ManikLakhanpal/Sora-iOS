//
//  ContentView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            if  userLoggedIn {
                HomeView()
            }
            else {
                WelcomeView()
            }
        }
        .onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel.shared)
}

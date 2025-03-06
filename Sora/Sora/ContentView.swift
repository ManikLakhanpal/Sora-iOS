//
//  ContentView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.isAuthenticated {
            if let user = viewModel.currentUser {
                HomeView()
            }
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel.shared)
}

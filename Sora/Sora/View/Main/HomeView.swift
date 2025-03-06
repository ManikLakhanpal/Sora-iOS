//
//  Home.swift
//  Sora
//
//  Created by Manik Lakhanpal on 06/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Already logged in")
        Button(action: {
            self.viewModel.logout()
            dismiss()
        }) {
            Text("Sign Out")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .padding(.bottom, 40)
    }
}


#Preview {
    HomeView()
}

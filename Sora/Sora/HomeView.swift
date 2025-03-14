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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var x: CGFloat = -UIScreen.main.bounds.width + 80
    
    var width: CGFloat {
        UIScreen.main.bounds.width - 80 // Adjusted width for better visibility
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.2)
                    ]),
                    startPoint: .topLeading ,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ZStack {
                    VStack {
                        TopBar(x: $x)
                        Spacer()
                        MainView()
                    }
                    .onAppear { x = -width } // Ensure sidebar starts hidden
                    
                    if x == 0 {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0)) { x = -width }
                            }
                    }
                }
                .offset(x: x + width)
                .animation(.easeInOut(duration: 0.4), value: x) // Ensure smooth movement
                
                SlideMenu()
                    .offset(x: x)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.width
                        if translation > 0 {
                            x = max(-width + translation, -width)
                        } else {
                            x = min(translation, 0)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.4)) {
                            if abs(value.translation.width) > width / 3 {
                                x = value.translation.width > 0 ? 0 : -width
                            } else {
                                x = x > -width / 2 ? 0 : -width
                            }
                        }
                    }
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel.shared)
}

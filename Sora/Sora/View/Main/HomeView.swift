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
    
    @State private var x: CGFloat = -UIScreen.main.bounds.width + 50
    
    var width: CGFloat {
        UIScreen.main.bounds.width - 50
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack {
                    Text("Home")
                        .onAppear {
                            x = -width // Initialize correctly
                        }
                }
                .offset(x: x + width)
                
                // Tap to close SlideMenu
                if x == 0 {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { x = -width }
                        }
                }
                
                SlideMenu()
                    .offset(x: x)
                    .shadow(color: Color.black.opacity(x != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
                    .animation(.easeInOut, value: x) // Smooth animation
            }
            .gesture(DragGesture().onChanged({ (value) in
                withAnimation {
                    if value.translation.width > 0 {
                        if x < 0 {
                            x = -width + value.translation.width
                        }
                    } else {
                        if x != -width {
                            x = value.translation.width
                        }
                    }
                }
            })
                .onEnded ({ (value) in
                    withAnimation {
                        if -x < width / 2 {
                            x = 0
                        }
                        else {
                            x = -width
                        }
                    }
                })
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}

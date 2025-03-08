//
//  SlideMenu.swift
//  Sora
//
//  Created by Manik Lakhanpal on 07/03/25.
//



import SwiftUI

var menuButtons = ["Profile", "Lists", "Topics", "Bookmarks", "Moments"]

struct SlideMenu: View {
    
    @State var show = true
    @State private var showLogoutAlert: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Spacer()
                    Button(action: {
                        self.showLogoutAlert.toggle()
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
            .padding(.horizontal, 20)
            .padding(.top, edges!.top == 0 ? 15 : edges?.top)
            .padding(.bottom, edges!.bottom == 0 ? 15 : edges?.bottom)
            .frame(width: width - 90)
            .ignoresSafeArea(.all, edges: .vertical)
            
            
            
        }
        .background(Color(.systemBackground))
        .confirmationDialog(
            "Are you sure?",
            isPresented: $showLogoutAlert) {
                Button("Log out", role: .destructive) {
                    viewModel.logout()
                }
            }
        
    }
}


#Preview {
    SlideMenu()
}

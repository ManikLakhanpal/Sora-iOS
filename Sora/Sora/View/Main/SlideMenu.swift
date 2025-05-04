//
//  SlideMenu.swift
//  Sora
//
//  Created by Manik Lakhanpal on 07/03/25.
//



import SwiftUI
import FirebaseAuth

struct SlideMenu: View {
    @State private var showLogoutAlert: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State var width = UIScreen.main.bounds.width

    var body: some View {
        GeometryReader { geometry in
            let topInset = geometry.safeAreaInsets.top
            let bottomInset = geometry.safeAreaInsets.bottom

            VStack {
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("\(Auth.auth().currentUser?.displayName ?? "Nil")")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("@\(Auth.auth().currentUser?.email ?? "Nil")")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 40)

                        Divider()

                        Spacer()

                        Divider()

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
                        .padding(.top)
                        .padding(.bottom, 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, topInset == 0 ? 15 : topInset)
                .padding(.bottom, bottomInset == 0 ? 15 : bottomInset)
                .frame(width: width - 90)
                .ignoresSafeArea(.all, edges: .vertical)
            }
            .confirmationDialog(
                "Are you sure?",
                isPresented: $showLogoutAlert) {
                    Button("Log out", role: .destructive) {
                        viewModel.logout()
                    }
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SlideMenu()
}

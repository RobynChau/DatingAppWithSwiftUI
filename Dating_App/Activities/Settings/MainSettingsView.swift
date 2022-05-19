//
//  MainSettingsView.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import SwiftUI

struct MainSettingsView: View {
    static let tag: String? = "Settings"
    @Environment(\.dismiss) var dismiss
    @State private var showingSettingsView = false
    @State private var showingSignInView = false
    @State private var showingLogInView = false
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        AboutUsView()
                    } label: {
                        Label("About Us", systemImage: Constants.icons["aboutus"]!)
                    }
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Personal Settings", systemImage: Constants.icons["personalsettings"]!)
                    }
                }

                Section {
                    Button {
                        try! FirebaseManager.shared.auth.signOut()
                        showingLogInView = true
                    } label: {
                        Label("Sign Out", systemImage: Constants.icons["signout"]!)
                    }
                }

            }
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showingSettingsView) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showingLogInView) {
                LoginView()
            }
        }
    }
}

struct MainSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingsView()
            .environmentObject(UnlockManager.init(currentUser: User.example))
    }
}

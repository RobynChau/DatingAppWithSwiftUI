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

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        //
                    } label: {
                        Label("About Us", systemImage: Constants.icons["aboutus"]!)
                    }

                    Button {
                        showingSettingsView = true
                    } label: {
                        Label("Personal Settings", systemImage: Constants.icons["personalsettings"]!)
                    }
                }

                Section {
                    Button {
                        try! FirebaseManager.shared.auth.signOut()
                        dismiss()
                    } label: {
                        Label("Sign Out", systemImage: Constants.icons["signout"]!)
                    }
                }

            }
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
    }
}

struct MainSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingsView()
    }
}

//
//  AboutUsView.swift
//  Dating_App
//
//  Created by Robyn Chau on 18/05/2022.
//

import SwiftUI

struct AboutUsView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        List {
            Section {
                NavigationLink {

                } label: {
                    Label("Term of Use", systemImage: "doc")
                }

                NavigationLink {

                } label: {
                    Label("User's Guide", systemImage: "doc.text")
                }

                NavigationLink {

                } label: {
                    Label("Contact Us", systemImage: "bubble.left.and.bubble.right")
                }
            }
            if let appVersion = appVersion {
                Section {
                    Text("Version: " + appVersion)
                }
            }
        }
        .navigationTitle("About Us")
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutUsView()
        }
    }
}

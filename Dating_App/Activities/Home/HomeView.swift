//
//  HomeView.swift
//  Dating_App
//
//  Created by Robyn Chau on 06/04/2022.
//

import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    @State private var showingSettings = false
    @Binding var tabSelection: String?
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    MiniDatingView(user: User.example)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Section("More to Explore") {
                    NavigationLink {
                        MatchView(currentUser: viewModel.currentUser)
                    } label: {
                        Label("Matches", systemImage: "person.wave.2")
                    }
                    NavigationLink {
                        LikedYouView(currentUser: viewModel.currentUser)
                    } label: {
                        Label("Liked You", systemImage: "person.wave.2")
                    }
                    NavigationLink {
                        SecondLookView(currentUser: viewModel.currentUser)
                    } label: {
                        Label("Second Look", systemImage: "person.wave.2")
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(tabSelection: .constant("Home"))
            .environmentObject(Users.init())
    }
}

//
//  MainView.swift
//  Dating_App
//
//  Created by Robyn Chau on 06/04/2022.
//
import SwiftUI

struct MainTabView: View {
    @State private var tabSelection: String? = "Home"
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView(tabSelection: $tabSelection)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: Constants.icons["home"]!)
                    Text("Home")
                }
            DatingView()
                .tag(DatingView.tag)
                .tabItem {
                    Image(systemName: Constants.icons["dating"]!)
                    Text("Match")
                }
            ProfileView()
                .tag(ProfileView.tag)
                .tabItem {
                    Image(systemName: Constants.icons["profile"]!)
                    Text("Edit Profile")
                }
            MainSettingsView()
                .tag(MainSettingsView.tag)
                .tabItem {
                    Image(systemName: Constants.icons["gear"]!)
                    Text("Settings")
                }
        }
        .tabViewStyle(.automatic)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

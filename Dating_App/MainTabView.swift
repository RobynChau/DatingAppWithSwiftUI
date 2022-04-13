//
//  MainView.swift
//  Dating_App
//
//  Created by Robyn Chau on 06/04/2022.
//
import SwiftUI

struct MainTabView: View {
    @StateObject var users = Users()
    @Binding var currentUser: User
    
    var body: some View {
        TabView {
            HomeView(users: users)
                .tag("Home View")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            DatingView(allUsers: users)
                .tag("Dating View")
                .tabItem {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text("Match")
                }
            ProfileView(users: users, currentUser: currentUser)
                .tag("Set Up")
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Edit Profile")
                }
        }
        .tabViewStyle(.automatic)
    }
}

//struct TabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}

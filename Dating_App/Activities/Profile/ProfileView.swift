//
//  ProfileView.swift
//  Dating_App
//
//  Created by Robyn Chau on 07/04/2022.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var users: Users
    @State private var isEditingProfile = false
    @State var currentUser: User
    var body: some View {
        VStack {
            Picker(selection: $isEditingProfile, label: Text("Profile View")) {
                Text("Profile Preview")
                    .tag(false)
                Text("Edit Profile")
                    .tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())

            if isEditingProfile {
                EditProfileView(users: users, currentUser: currentUser)
            } else {
                PreviewProfileView(user: currentUser)
            }
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(users: Users.init(), currentUser: User.example)
    }
}

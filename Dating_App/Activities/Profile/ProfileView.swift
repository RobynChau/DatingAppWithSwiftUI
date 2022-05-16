//
//  ProfileView.swift
//  Dating_App
//
//  Created by Robyn Chau on 07/04/2022.
//

import SwiftUI

struct ProfileView: View {
    static let tag: String? = "Profile"
    @State private var isEditingProfile = false
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
                EditProfileView()
            } else {
                PreviewProfileView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

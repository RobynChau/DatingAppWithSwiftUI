//
//  LikedYouView.swift
//  Dating_App
//
//  Created by Robyn Chau on 14/05/2022.
//

import SwiftUI

struct LikedYouView: View {
    @State var currentUser: User
    var body: some View {
        List {
            ForEach(currentUser.liked, id: \.id) { match in
                VStack {
                    Text(match.id)
                }
            }
        }
        .navigationTitle("Liked You")
    }
}

struct LikedYouView_Previews: PreviewProvider {
    static var previews: some View {
        LikedYouView(currentUser: User.example)
    }
}

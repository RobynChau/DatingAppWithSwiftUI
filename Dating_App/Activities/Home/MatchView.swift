//
//  MatchView.swift
//  Dating_App
//
//  Created by Robyn Chau on 14/05/2022.
//

import SwiftUI

struct MatchView: View {
    @State var currentUser: User
    var body: some View {
        List {
            ForEach(currentUser.match, id: \.id) { match in
                VStack {
                    Text(match.id)
                }
            }
        }
        .navigationTitle("Match")
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(currentUser: User.example)
    }
}

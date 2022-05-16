//
//  SecondLookView.swift
//  Dating_App
//
//  Created by Robyn Chau on 14/05/2022.
//

import SwiftUI

struct SecondLookView: View {
    @State var currentUser: User
    var body: some View {
        List {
            ForEach(currentUser.pass, id: \.id) { match in
                VStack {
                    Text(match.id)
                }
            }
        }
        .navigationTitle("Second Look")
    }
}

struct SecondLookView_Previews: PreviewProvider {
    static var previews: some View {
        SecondLookView(currentUser: User.example)
    }
}

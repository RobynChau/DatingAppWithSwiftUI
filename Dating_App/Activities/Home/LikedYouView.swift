//
//  LikedYouView.swift
//  Dating_App
//
//  Created by Robyn Chau on 14/05/2022.
//

import SwiftUI

struct LikedYouView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        List {
            ForEach(viewModel.currentUser.liked, id: \.id) { match in
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
        LikedYouView()
    }
}

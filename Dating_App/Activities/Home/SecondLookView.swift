//
//  SecondLookView.swift
//  Dating_App
//
//  Created by Robyn Chau on 14/05/2022.
//

import SwiftUI

struct SecondLookView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.currentUser.pass, id: \.id) { match in
                VStack {
                    Text(match.id)
                }
            }
            .refreshable {
                viewModel.fetchCurrentUser()
            }
        }
        .navigationTitle("Second Look")
    }
}

struct SecondLookView_Previews: PreviewProvider {
    static var previews: some View {
        SecondLookView()
    }
}

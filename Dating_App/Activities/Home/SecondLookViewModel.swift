//
//  SecondLookViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 19/05/2022.
//

import Foundation

extension SecondLookView {
    class ViewModel: ObservableObject {
        @Published var currentUser = User.example

        init() {
            fetchCurrentUser()
        }

        func fetchCurrentUser() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: User.self) { result in
                switch result {
                case .success(let retrieved):
                    self.currentUser = retrieved
                case.failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

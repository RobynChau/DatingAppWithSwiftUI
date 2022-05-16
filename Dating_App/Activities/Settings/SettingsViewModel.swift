//
//  SettingsViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation

extension SettingsView {
    class ViewModel: ObservableObject {
        @Published var currentUser = User.example
        @Published var showingLogInView = false

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

        func deleteUser() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

            FirebaseManager.shared.firestore.collection("users").document(uid).delete()

            let user = FirebaseManager.shared.auth.currentUser
            user?.delete(completion: { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                  }
            })

            showingLogInView = true
        }
    }
}

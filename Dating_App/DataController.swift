//
//  DataController.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation

class DataController: ObservableObject {
    @Published var currentUser: User?
    @Published var allUsers = Users()

    @Published var isUserCurrentlyLoggedOut = false

    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        self.fetchCurrentUser()
    }

    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: User.self) { result in
            switch result {
            case .success(let retrieved):
                self.currentUser = retrieved
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

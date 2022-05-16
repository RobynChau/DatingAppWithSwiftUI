//
//  DatingViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation

extension DatingView {
    class ViewModel: ObservableObject {
        @Published var currentUser: User?
        @Published var isUserCurrentlyLoggedOut = false
        @Published var allUsers = Users()

        init() {
            DispatchQueue.main.async {
                self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
            }

            fetchCurrentUser()
        }

        func removeCard(at index: Int) {
            guard index >= 0 else {return}
            allUsers.users.remove(at: index)
        }

        var filterUsers: [User] {
            allUsers.users
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

        func handledLikeAction(index: Int) {
            // Add B info to A's like
            currentUser!.like.append(Swipe(id: filterUsers[index].uid, timestamp: Date()))
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            try! FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: currentUser, merge: false)
            // Add A info to B's liked
            FirebaseManager.shared.firestore.collection("users").whereField("uid", isEqualTo: filterUsers[index].uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        guard querySnapshot!.documents.count == 1 else {
                            fatalError("There are 2 users with the same uid")
                        }
                        for document in querySnapshot!.documents {
                            var likedUser = User(data: document.data())
                            likedUser.liked.append(Swipe(id: self.currentUser!.uid, timestamp: Date()))
                            try! FirebaseManager.shared.firestore.collection("users").document(likedUser.uid).setData(from: likedUser, merge: false)
                        }
                    }
                }
        }

        func handledPassAction(index: Int) {
            currentUser!.pass.append(Swipe(id: filterUsers[index].uid, timestamp: Date()))
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            try! FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: currentUser, merge: false)
        }
    }
}

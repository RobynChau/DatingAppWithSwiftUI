//
//  LoginViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation

extension LoginView {
    class ViewModel: ObservableObject {

        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""

        @Published var currentUser = User.example

        @Published var showingHomeScreen = false
        @Published var showingSignUpView = false

        @Published var isUserCurrentlyLoggedIn = false

        init() {
            DispatchQueue.main.async {
                self.isUserCurrentlyLoggedIn = FirebaseManager.shared.auth.currentUser?.uid != nil
            }

            initCurrentUser()
        }

        func initCurrentUser() {
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

        func validEmail(email: String) -> Bool {
            let emailPattern = #"^\S+@\S+\.\S+$"#
            return email.range(
                of: emailPattern,
                options: .regularExpression
            ) != nil
        }

        func loginUser(email: String, password: String, unlockManger: UnlockManager) {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.alertTitle = "Failed to log in."
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                    return
                }

                self.fetchCurrentUser(unlockManager: unlockManger)
                self.isUserCurrentlyLoggedIn.toggle()
            }
        }

        func fetchCurrentUser(unlockManager: UnlockManager) {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: User.self) { result in
                switch result {
                case .success(let retrieved):
                    self.currentUser = retrieved
                    unlockManager.currentUser = retrieved

                case.failure(let error):
                    self.alertTitle = "Failed to get fetch current user"
                    self.alertMessage = "\(error.localizedDescription)"
                    self.showingAlert = true
                }
            }
        }

        func createUser(email: String, password: String) {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.alertTitle = "Failed to create account."
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                    return
                }

                self.showingSignUpView.toggle()
            }
        }
    }
}

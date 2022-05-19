//
//  MainSettingsViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation


extension MainSettingsView {
    class ViewModel: ObservableObject {
        init() {
        }

        func signOut() {
            try! FirebaseManager.shared.auth.signOut()
        }
    }
}

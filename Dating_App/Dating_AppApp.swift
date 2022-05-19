//
//  Dating_AppApp.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import SwiftUI

@main
struct Dating_AppApp: App {
    @StateObject var unlockManager = UnlockManager(currentUser: User.example)

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(unlockManager)
        }
    }
}

//
//  FirebaseManager.swift
//  Dating_App
//
//  Created by Robyn Chau on 13/04/2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: NSObject {

    let auth: Auth

    let storage: Storage

    let firestore: Firestore

    static let shared = FirebaseManager()

    var currentUser: User?

    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}

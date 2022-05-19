//
//  SettingsViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation
import CoreLocation

extension SettingsView {
    class ViewModel: ObservableObject {
        @Published var currentUser = User.example
        @Published var showingLogInView = false
        @Published var showingUnlockScreen = false

        @Published var locationFetcher = LocationFetcher()

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

        func save() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            try! FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: self.currentUser, merge: false)
        }

        func convertLocation() async {
            if let data = locationFetcher.lastKnownLocation {
                currentUser.latitude = data.latitude
                currentUser.longitude = data.longitude
            } else {
                return
            }

            let placeMarks = await getPlace(for: CLLocation(latitude: currentUser.latitude, longitude: currentUser.longitude))
            if let placeMarks = placeMarks {
                if let country = placeMarks[0].country {
                    currentUser.countryName = country
                }
                if let state = placeMarks[0].administrativeArea {
                    currentUser.locationName = state
                }
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
            else {
                return
            }
        }

        func getPlace(for location: CLLocation) async -> [CLPlacemark]? {
            let geoCoder = CLGeocoder()
            return try! await geoCoder.reverseGeocodeLocation(location)
        }
    }
}

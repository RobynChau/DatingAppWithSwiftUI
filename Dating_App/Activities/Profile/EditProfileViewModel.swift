//
//  EditProfileViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import Foundation
import UIKit
import CoreLocation

extension EditProfileView {
    class ViewModel: ObservableObject {
        @Published var currentUser = User.example

        @Published var showingGender = true

        @Published var uiImages = [UIImage?](repeating: nil, count: 6)
        
        @Published var imageIndex = 0

        @Published var locationFetcher = LocationFetcher()

        @Published var showingDatingLocationView = false

        @Published var messageTitle = ""
        @Published var messageContent = ""
        @Published var showingMessage = false

        @Published var showingImagePicker = false

        init() {
            fetchCurrentUser()
        }

        func fetchCurrentUser() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: User.self) { result in
                switch result {
                case .success(let retrieved):
                    self.currentUser = retrieved
                    self.uiImages = self.currentUser.uiImages
                case.failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }

        func convertLocation() async {
            if let data = locationFetcher.lastKnownLocation {
                currentUser.latitude = data.latitude
                currentUser.longitude = data.longitude
            } else {
                messageTitle = "Failed to find location"
                messageContent = "Please allow us to use your current location and try again."
                showingMessage = true
            }

            let placeMarks = await getPlace(for: CLLocation(latitude: currentUser.latitude, longitude: currentUser.longitude))
            if let placeMarks = placeMarks {
                if let country = placeMarks[0].country {
                    currentUser.countryName = country
                }
                if let state = placeMarks[0].administrativeArea {
                    currentUser.locationName = state
                }
            }
            else {
                messageTitle = "Failed to convert location"
                messageContent = "Please try again later"
                showingMessage = true
            }
        }


        func save() {
            var imageDatas = [Data?]()

            for uiImage in uiImages {
                if let uiImage = uiImage {
                    if let data = uiImage.jpegData(compressionQuality: 0.01) {
                        imageDatas.append(data)
                    }
                } else {
                    imageDatas.append(nil)
                }
            }
            currentUser.images = imageDatas
        }

        func updateUser() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            try! FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: self.currentUser, merge: false)
        }

        func getPlace(for location: CLLocation) async -> [CLPlacemark]? {
            let geoCoder = CLGeocoder()
            return try! await geoCoder.reverseGeocodeLocation(location)
        }

        func validateInput() {

        }
    }
}

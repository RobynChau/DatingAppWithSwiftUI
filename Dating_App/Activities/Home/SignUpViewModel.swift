//
//  SignUpViewModel.swift
//  Dating_App
//
//  Created by Robyn Chau on 15/05/2022.
//

import Foundation
import CoreLocation
import UIKit

extension SignUpView {
    class ViewModel: ObservableObject {

        @Published var dateOfBirth = Date()
        @Published var name = ""
        @Published var genderIdentity = ""
        @Published var genderInSearch = "" // Gender user represents in searching (Man/Woman)
        @Published var genderInterestedIn = "" // Gender user is interested in (Man/Woman)
        @Published var showingNextStep = false
        @Published var step = 1
        @Published var showingConfirmationDialog = false
        @Published var hasChangedDateOfBirth = false
        @Published var showingGender = false
        @Published var showingImagePicker = false
        @Published var uiImages = [UIImage?].init(repeating: nil, count: 9)
        @Published var hasAddedPhoto = false
        @Published var imageIndex = 0
        @Published var longitude: Double = 0.0
        @Published var latitude: Double = 0.0
        @Published var locationName = ""
        @Published var countryName = ""

        @Published var messageTitle = ""
        @Published var messageContent = ""
        @Published var showingMessage = false


        private var locationFetcher = LocationFetcher()


        func startLocationFetcher() {
            locationFetcher.start()
        }

        func getPlace(for location: CLLocation) async -> [CLPlacemark]? {
            let geoCoder = CLGeocoder()
            return try! await geoCoder.reverseGeocodeLocation(location)
        }

        func convertLocation() async {
            if let data = locationFetcher.lastKnownLocation {
                self.latitude = data.latitude
                self.longitude = data.longitude
            } else {
                messageTitle = "Failed to find location"
                messageContent = "Please allow us to use your current location and try again."
                showingMessage = true
            }

            let placeMarks = await getPlace(for: CLLocation(latitude: latitude, longitude: longitude))
            if let placeMarks = placeMarks {
                if let country = placeMarks[0].country {
                    self.countryName = country
                }
                if let state = placeMarks[0].administrativeArea {
                    self.locationName = state
                }
            }
            else {
                messageTitle = "Failed to convert location"
                messageContent = "Please try again later"
                showingMessage = true
            }
        }

        func calculateAge() -> Int {
            return Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year!
        }

        private func saveImages(for user: inout User) {
            var imageDatas = [Data?]()

            for uiImage in uiImages {
                if let uiImage = uiImage {
                    if let data = uiImage.jpegData(compressionQuality: 0.1) {
                        imageDatas.append(data)
                    }
                } else {
                    imageDatas.append(nil)
                }
            }
            user.images = imageDatas
        }

        func save() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                messageTitle = "Failed to retrieve current user"
                showingMessage = true
                return
            }

            var user = User(uid: uid, name: name, dateOfBirth: dateOfBirth, genderIdentity: genderIdentity, longitude: longitude, latitude: latitude, locationName: locationName, countryName: countryName, genderInSearch: genderInSearch, genderInterestedIn: genderInterestedIn)

            saveImages(for: &user)

            do {
                try FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: user)
            } catch let error {
                messageTitle = "Failed to store user information"
                messageContent = error.localizedDescription
                showingMessage = true
                return
            }
        }
    }
}

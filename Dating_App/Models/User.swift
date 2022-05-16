//
//  User.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct User: Codable, Identifiable, Equatable {
    var id: String { uid }

    // Basic Information
    var uid: String
    var name: String
    var dateOfBirth: Date
    var genderIdentity: String // Gender identity of user, includes all types of gender
    var showingGender: Bool = true
    var longitude: Double
    var latitude: Double
    var locationName: String
    var countryName: String

    var genderInSearch: String // Gender user represents in searching (Man/Woman)
    var genderInterestedIn: String // Gender user is interested in (Man/Woman)

    // Additional Information
    var intro: String?
    var height: Int?
    var relationshipTypes: [String]?
    var kidsNumber: Int?
    var smokingHabit: Int?
    var drinkingHabit: Int?
    var religion: Int?
    var educationLevel: Int?
    var universityName: String?
    var jobTitle: String?
    var hobbies: [String]?
    var images = [Data?]()

    // An array of users that User liked or swiped right
    var like = [Swipe]()
    // An array of users that liked or swiped right for User
    var liked = [Swipe]()
    //An array of users that User passed or swiped left
    var pass = [Swipe]()

    // Match Array

    var fullVersionUnlocked: Bool = false

    var age: Int {
        return Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year!
    }

    var informationList: [(String, String)?] {
        var info = [(String, String)?]()
        if let lookingFor = relationshipTypes {
            info.append(("Looking for \(lookingFor.joined(separator: ", ").lowercased())", Constants.icons["lookingFor"]!))
        }
        info.append(("Located \(locationName), \(countryName)", Constants.icons["location"]!))
        if let height = height {
            info.append(("\(height) cm", Constants.icons["height"]!))
        }
        if let kidsNumber = kidsNumber {
            info.append((Constants.kidsOptions[kidsNumber], Constants.icons["kids"]!))
        }
        if let smokingHabit = smokingHabit {
            info.append((Constants.smokingOptions[smokingHabit],  Constants.icons["smoking"]!))
        }
        if let drinkingHabit = drinkingHabit {
            info.append((Constants.drinkingOptions[drinkingHabit],  Constants.icons["drinking"]!))
        }
        if let religion = religion {
            info.append((Constants.religions[religion],  Constants.icons["religion"]!))
        }
        if let educationLevel = educationLevel {
            info.append((Constants.educationLevels[educationLevel], Constants.icons["education"]!))
        }
        if let universityName = universityName {
            info.append((universityName, Constants.icons["education"]!))
        }
        if let jobTitle = jobTitle {
            info.append((jobTitle, Constants.icons["job"]!))
        }
        return info
    }

    var coverImage: Image? {
        if images.count != 0 {
            if let coverImageData = images[0] {
                if let coverUIImage = UIImage(data: coverImageData) {
                    return Image(uiImage: coverUIImage)
                }
            }
        }
        return nil
    }

    var additionalImages: [Image?] {
        var additionalImages = [Image?]()
        for imageData in images.dropFirst() {
            if let imageData = imageData {
                if let uiImage = UIImage(data: imageData) {
                    additionalImages.append(Image(uiImage: uiImage))
                }
            }
        }
        return additionalImages
    }

    var uiImages: [UIImage?] {
        var uiImages = [UIImage?]()
        for imageData in images {
            if let imageData = imageData {
                uiImages.append(UIImage(data: imageData))
            } else {
                uiImages.append(nil)
            }
        }
        return uiImages
    }

    var wrappedIntro: String {
        intro ?? ""
    }
    var wrappedHeight: Int {
        height ?? 0
    }
    var wrappedRelationshipTypes: [String] {
        relationshipTypes ?? []
    }
    var wrappedKidsNumber: Int {
        kidsNumber ?? 0
    }
    var wrappedSmokingHabit: Int {
        smokingHabit ?? 0
    }
    var wrappedDrinkingHabit: Int {
        drinkingHabit ?? 0
    }
    var wrappedReligion: Int {
        religion ?? 0
    }
    var wrappedEducationLevel: Int {
        educationLevel ?? 0
    }
    var wrappedUniversityName: String {
        universityName ?? ""
    }

    var wrappedJobTitle: String {
        jobTitle ?? ""
    }
    var wrappedHobbies: [String] {
        hobbies ?? []
    }

    var match: [Swipe] {
        return like.filter { swipe1 in
            liked.contains { swipe2 in
                swipe1.id == swipe2.id
            }
        }
    }
}

extension User {
    static var example: User {
        let user = User(uid: "", name: "", dateOfBirth: Date(), genderIdentity: "", longitude: 0, latitude: 0, locationName: "", countryName: "", genderInSearch: "", genderInterestedIn: "")
        return user
    }

    init(data: [String: Any]) {
        self.uid = data["uid"] as! String
        self.name = data["name"] as! String
        self.dateOfBirth = (data["dateOfBirth"] as! Timestamp).dateValue()
        self.genderIdentity = data["genderIdentity"] as! String
        self.showingGender = data["showingGender"] as! Bool
        self.longitude = data["longitude"] as! Double
        self.latitude = data["latitude"] as! Double
        self.locationName = data["locationName"] as! String
        self.countryName = data["countryName"] as! String
        self.genderInSearch = data["genderInSearch"] as! String
        self.genderInterestedIn = data["genderInterestedIn"] as! String
        self.intro = data["intro"] as! String?
        self.height = data["height"] as! Int?
        self.relationshipTypes = data["relationshipTypes"] as! [String]?
        self.kidsNumber = data["kidsNumber"] as! Int?
        self.smokingHabit = data["smokingHabit"] as! Int?
        self.drinkingHabit = data["drinkingHabit"] as! Int?
        self.religion = data["religion"] as! Int?
        self.educationLevel = data["educationLevel"] as! Int?
        self.universityName = data["universityName"] as! String?
        self.jobTitle = data["jobTitle"] as! String?
        self.hobbies = data["hobbies"] as! [String]?
        self.images = data["images"] as! [Data?]
    }
}

class Users: ObservableObject {
    @Published var users = [User]()
    
    init() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    self.users.append(User(data: document.data()))
                }
            }
        }
    }
}

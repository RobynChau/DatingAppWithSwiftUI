//
//  User.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    var id = UUID()
    // Basic Information
    var name: String
    var age: Int
    var height: Int?
    var gender: String
    var showingGender: Bool = true
    var longitude: Double
    var latitude: Double
    var locationName: String
    var country: String

    // Additional Information
    var intro: String?
    var lookingFor: [String]?
    var kidsNumber: Int?
    var smokingHabit: Int?
    var drinkingHabit: Int?
    var religion: Int?
    var educationLevel: Int?
    var universityName: String?
    var jobTitle: String?
    var hobbies: [String]?
    var images = [Data?]()

    static var example: User {
        var user = User(name: "Example User", age: 21, height: 170, gender: "Male", longitude: 0, latitude: 0, locationName: "Example Location", country: "Example Country")
        for i in 1..<6 {
            let uiImage = UIImage(named: "person_\(i)")
            if let data = uiImage!.jpegData(compressionQuality: 0.8) {
                user.images.append(data)
            }
        }
        return user
    }

    static var currentUser: User {
        var user = User(name: "Robyn Chau", age: 21, height: 170, gender: "Man", showingGender: true, longitude: 102, latitude: 103, locationName: "Cupertino", country: "US", intro: "I am Robyn Chau", lookingFor: ["Friendship", "Something Casual"], kidsNumber: 1, smokingHabit: 1, drinkingHabit: 1, religion: 5, educationLevel: 1, universityName: "HCMUS", jobTitle: "Developer")
        for i in 1..<10 {
            if let uiImage = UIImage(named: "person_\(i)") {
                if let data = uiImage.jpegData(compressionQuality: 0.8) {
                    user.images.append(data)
                } else {
                    user.images.append(nil)
                }
            } else {
                user.images.append(nil)
            }
        }
        return user
    }

    var informationList: [(String, String)?] {
        var info = [(String, String)?]()
        if let lookingFor = lookingFor {
            info.append(("Looking for \(lookingFor.joined(separator: ", ").lowercased())", Constants.icons["lookingFor"]!))
        }
        info.append(("Located \(locationName), \(country)", Constants.icons["location"]!))
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
}

class Users: ObservableObject {
    @Published var users = [User]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(users) {
                UserDefaults.standard.set(encoded, forKey: "Users")
            }
        }
    }
    init() {
        if let data = UserDefaults.standard.data(forKey: "Users") {
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                users = decoded
                return
            }
        }
        users = []
    }
}

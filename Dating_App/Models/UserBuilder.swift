//
//  UserBuilder.swift
//  Dating_App
//
//  Created by LAP14177 on 19/05/2022.
//

import Foundation
import FirebaseFirestore

public class UserBuilder {
    // Basic Information
    var uid = ""
    var name = ""
    var dateOfBirth = Date()
    var genderIdentity = "" // Gender identity of user, includes all types of gender
    var showingGender = true
    var longitude = 0.0
    var latitude = 0.0
    var locationName = ""
    var countryName = ""

    var genderInSearch = "" // Gender user represents in searching (Man/Woman)
    var genderInterestedIn = "" // Gender user is interested in (Man/Woman)

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

    var fullVersionUnlocked: Bool = false
    
    public func addUID(_ uid: String) {
        self.uid = uid
    }
    
    public func addName(_ name: String) {
        self.name = name
    }
    
    public func addDateOfBirth(_ dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
    }
    
    public func addGenderIdentity(_ genderIdentity: String) {
        self.genderIdentity = genderIdentity
    }
    
    public func addShowingGender(_ showingGender: Bool) {
        self.showingGender = showingGender
    }
    
    public func addLongitude(_ longitude: Double) {
        self.longitude = longitude
    }
    
    public func addLatitude(_ latitude: Double) {
        self.latitude = latitude
    }
    
    public func addLocationName(_ locationName: String) {
        self.locationName = locationName
    }
    
    public func addCountryName(_ countryName: String) {
        self.countryName = countryName
    }
    
    public func addGenderInSearch(_ genderInSearch: String) {
        self.genderInSearch = genderInSearch
    }
    
    public func addGenderInterestedIn(_ genderInterestedIn: String) {
        self.genderInterestedIn = genderInterestedIn
    }
    
    public func addIntro(_ intro: String?) {
        self.intro = intro
    }
    
    public func addHeight(_ height: Int?) {
        self.height = height
    }
    
    public func addRelationshipTypes(_ relationshipTypes: [String]?) {
        self.relationshipTypes = relationshipTypes
    }
    
    public func addKidsNumber(_ kidsNumber: Int?) {
        self.kidsNumber = kidsNumber
    }
    
    public func addSmokingHabit(_ smokingHabit: Int?) {
        self.smokingHabit = smokingHabit
    }
    
    public func addDrinkingHabit(_ drinkingHabit: Int?) {
        self.drinkingHabit = drinkingHabit
    }
    
    public func addReligion(_ religion: Int?) {
        self.religion = religion
    }
    
    public func addEducationLevel(_ educationLevel: Int?) {
        self.educationLevel = educationLevel
    }
    
    public func addUniversityName(_ universityName: String?){
        self.universityName = universityName
    }
    
    public func addJobTitle(_ jobTitle: String?) {
        self.jobTitle = jobTitle
    }
    
    public func addHobbies(_ hobbies: [String]?) {
        self.hobbies = hobbies
    }
    
    public func addImages(_ images: [Data?]) {
        self.images = images
    }

    public func addFullVersionUnlocked(_ fullVersionUnlocked: Bool) {
        self.fullVersionUnlocked = fullVersionUnlocked
    }
    
    func build() -> User {
        return User(uid: uid, name: name, dateOfBirth: dateOfBirth, genderIdentity: genderIdentity, showingGender: showingGender, longitude: longitude, latitude: latitude, locationName: locationName, countryName: countryName, genderInSearch: genderInSearch, genderInterestedIn: genderInterestedIn, intro: intro, height: height, relationshipTypes: relationshipTypes, kidsNumber: kidsNumber, smokingHabit: smokingHabit, drinkingHabit: drinkingHabit, religion: religion, educationLevel: educationLevel, universityName: universityName, jobTitle: jobTitle, hobbies: hobbies, images: images)
    }
}

public class UserBuilderShop {
    func createUserFromData(using builder: UserBuilder, data: [String: Any]) -> User {
        builder.addUID(data["uid"] as! String)
        builder.addName(data["name"] as! String)
        builder.addDateOfBirth((data["dateOfBirth"] as! Timestamp).dateValue())
        builder.addGenderIdentity(data["genderIdentity"] as! String)
        builder.addShowingGender(data["showingGender"] as! Bool)
        builder.addLongitude(data["longitude"] as! Double)
        builder.addLatitude(data["latitude"] as! Double)
        builder.addLocationName(data["locationName"] as! String)
        builder.addCountryName(data["countryName"] as! String)
        builder.addGenderInSearch(data["genderInSearch"] as! String)
        builder.addGenderInterestedIn(data["genderInterestedIn"] as! String)
        builder.addIntro(data["intro"] as! String?)
        builder.addHeight(data["height"] as! Int?)
        builder.addRelationshipTypes(data["relationshipTypes"] as! [String]?)
        builder.addKidsNumber(data["kidsNumber"] as! Int?)
        builder.addSmokingHabit(data["smokingHabit"] as! Int?)
        builder.addDrinkingHabit(data["drinkingHabit"] as! Int?)
        builder.addReligion(data["religion"] as! Int?)
        builder.addEducationLevel(data["educationLevel"] as! Int?)
        builder.addUniversityName(data["universityName"] as! String?)
        builder.addJobTitle(data["jobTitle"] as! String?)
        builder.addHobbies(data["hobbies"] as! [String]?)
        builder.addImages(data["images"] as! [Data?])
        builder.addFullVersionUnlocked(data["fullVersionUnlocked"] as! Bool)
        
        return builder.build()
    }
    
    func createExampleUser(using builder: UserBuilder) -> User {
        builder.build()
    }
}

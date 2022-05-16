//
//  Filters.swift
//  Dating_App
//
//  Created by Robyn Chau on 22/04/2022.
//

import Foundation

struct Filters: Codable {
    var genderInterestedIn: String
    var age: Int
    var advancedFilters: AdvancedFilters?
}

extension Filters {
    
    init(genderInterested: String, age: Int, height: Int?, relationshipTypes: [String]?, kidsNumber: Int?, smokingHabit: Int?, drinkingHabit: Int?) {
        self.genderInterestedIn = genderInterested
        self.age = age
        self.advancedFilters = AdvancedFilters()
    }
}

struct AdvancedFilters: Codable {
    var height: Int?
    var relationshipTypes: [String]?
    var kidsNumber: Int?
    var smokingHabit: Int?
    var drinkingHabit: Int?
    var religion: Int?
    var educationLevel: Int?
    var hobbies: [String]?
    var images = [Data?]()
}



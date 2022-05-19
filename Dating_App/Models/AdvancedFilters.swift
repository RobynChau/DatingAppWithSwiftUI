//
//  AdvancedFilters.swift
//  Dating_App
//
//  Created by Robyn Chau on 22/04/2022.
//

import Foundation

struct AdvancedFilters: Identifiable, Codable, Equatable {
    var id: String
    var minAge: Int?
    var maxAge: Int?
    var minHeight: Int?
    var maxHeight: Int?
    var relationshipTypes: [String]?
    var kidsNumber: Int?
    var smokingHabit: Int?
    var drinkingHabit: Int?
    var religion: Int?
    var educationLevel: Int?

    var minAgeKey: String? {
        minAge != nil ? "Minimum Age" : nil
    }

    var maxAgeKey: String? {
        maxAge != nil ? "Minimum Age" : nil
    }

    var minHeightKey: String? {
        minHeight != nil ? "Minimum Age" : nil
    }

    var maxHeightKey: String? {
        maxHeight != nil ? "Minimum Age" : nil
    }
    var relationshipTypesKey: String? {
        relationshipTypes != nil ? "Minimum Age" : nil
    }
    var kidsNumberKey: String? {
        kidsNumber != nil ? "Minimum Age" : nil
    }
    var smokingHabitKey: String? {
        smokingHabit != nil ? "Minimum Age" : nil
    }
    var drinkingHabitKey: String? {
        drinkingHabit != nil ? "Minimum Age" : nil
    }
    var religionKey: String? {
        religion != nil ? "Minimum Age" : nil
    }

    var educationLevelKey: String? {
        educationLevel != nil ? "Minimum Age" : nil
    }

    static var example: AdvancedFilters {
        return AdvancedFilters(id: "")
    }
}



//
//  University.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import Foundation

struct University: Decodable, Identifiable {
    var id: String { name }
    var web_pages: [String]
    var name: String
    var alpha_two_code: String
    var state_province: String?
    var domains: [String]
    var country: String

    static let allUniversities = Bundle.main.decode([University].self, from: "Universities.json")
    static let example = allUniversities[0]

    static let otherUniversity = allUniversities.last!

}

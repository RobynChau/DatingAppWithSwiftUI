//
//  LookingForPicker.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct LookingForPicker: View {
    @Binding var types: [String]
    var body: some View {
        Form {
            Section("What type of relationship are you looking for?\nSelect all that apply.") {
                List {
                    ForEach(Constants.relationshipTypes, id: \.self) { type in
                        Button {
                            addRelationshipType(type: type)
                        } label: {
                            Label(type, systemImage: types.contains(type) ? "circle.fill" : "circle")
                        }
                    }
                }
            }
            .navigationTitle("Looking For")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func addRelationshipType(type: String) {
        if type == "Prefer Not to Say" {
            types.removeAll()
            types.append("Prefer Not to Say")
        } else {
            if types.contains("Prefer Not to Say") {
                types.remove(at: types.firstIndex(of: "Prefer Not to Say")!)
            }
            if types.contains(type) {
                types.remove(at: types.firstIndex(of: type)!)
            } else {
                types.append(type)
            }
        }
    }
}

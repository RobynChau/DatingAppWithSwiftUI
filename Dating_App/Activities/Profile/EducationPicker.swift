//
//  EducationPicker.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct EducationPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @Binding var university: String
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(filteredUniversities) { university in
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text(university.name)
                            Text(university.country)
                                .foregroundColor(.secondary)
                        }
                        Divider()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.university = university.name
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.horizontal)
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a university")
                .disableAutocorrection(true)
            }
            .navigationTitle("Education Picker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var filteredUniversities: [University] {
        if searchText.isEmpty {
            return University.allUniversities
        } else {
            if University.allUniversities.filter({ $0.name.localizedCaseInsensitiveContains(searchText) }).isEmpty {
                return [University.otherUniversity]
            } else {
                return University.allUniversities.filter{ $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
}


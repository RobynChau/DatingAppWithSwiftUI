//
//  OccupationPicker.swift
//  Dating_App
//
//  Created by Robyn Chau on 05/04/2022.
//

import SwiftUI

struct OccupationPicker: View {
    @Binding var occupationTitle: String
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    let allOccupationTitles = Bundle.main.decode([String].self, from: "Occupations.json", keyDecodingStrategy: .convertFromSnakeCase).map{ $0.capitalized }
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(filteredOccupationTitles, id: \.self) { title in
                    VStack(alignment: .leading) {
                        Text(title)
                        Divider()
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal)
                    .onTapGesture {
                        occupationTitle = title
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a job title")
                .disableAutocorrection(true)
            }
            .navigationTitle("Job Title Picker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    var filteredOccupationTitles: [String] {
        if searchText.isEmpty {
            return allOccupationTitles
        } else {
            if allOccupationTitles.filter({ $0.localizedCaseInsensitiveContains(searchText) }).isEmpty {
                return ["Other"]
            } else {
                return allOccupationTitles.filter{ $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }

}

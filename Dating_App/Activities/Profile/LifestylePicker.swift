//
//  LifestylePicker.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct LifestylePicker: View {
    @Environment(\.presentationMode) var presentationMode
    let navigationTitle: String
    @Binding var choice: Int
    let options: [String]

    var body: some View {
        Form {
            Section{
                List {
                    ForEach(options.filter{ !$0.isEmpty }, id: \.self) { option in
                        Button {
                            choice = options.firstIndex(of: option)!
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label(option, systemImage: options[choice] == option ? "circle.fill" : "circle")
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

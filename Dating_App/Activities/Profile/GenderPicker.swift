//
//  GenderPicker.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct GenderPicker: View {
    @Binding var gender: String
    @Binding var rootIsActive : Bool
    @Binding var showingGender: Bool
    @Environment(\.presentationMode) var presentationMode
    let isOtherGenders: Bool
    var body: some View {
        Form {
            Section(!isOtherGenders ? "What is your gender?": "What gender do you identify as?") {
                List {
                    ForEach(!isOtherGenders ? Constants.genders : Constants.broadOtherGenders, id: \.self) { choice in
                        Button {
                            gender = choice
                            if !isOtherGenders {
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.rootIsActive = false
                            }
                        } label: {
                            Label(choice, systemImage: gender == choice ? "circle.fill" : "circle")
                        }
                    }
                }
            }
            Section("Do you want to show your gender?") {
                Toggle("Show gender?", isOn: $showingGender)
            }
            Group {
                if !isOtherGenders {
                    Section(footer: Text("Please refer to this option if you cannot reflect identity")) {
                        NavigationLink(destination: GenderPicker(gender: $gender, rootIsActive: self.$rootIsActive, showingGender: $showingGender, isOtherGenders: true)) {
                            Text("Let me be more specific")
                        }
                    }
                }
            }
        }
        .navigationTitle("Gender Identity")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  SettingView.swift
//  Dating_App
//
//  Created by Robyn Chau on 19/04/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    @ObservedObject var viewModel = ViewModel()


    let advancedFilterOptions = ["kidsOptions", "smokingOptions", "drinkingOptions", "relationshipTypes", "religions", "educationLevels", "jobTitle", ]

    @State private var showingUnlockScreen = false
    static let tag: String? = "Settings"
    var body: some View {
        NavigationView {
            List {
                Section("Filter") {
                    VStack(alignment: .leading) {
                        Text("Show me in searches for")
                            .font(.subheadline)
                        //.foregroundColor(.secondary)
                        Picker("Show me in searches for...", selection: $viewModel.currentUser.genderInSearch) {
                            Text("Women")
                                .tag("Women")
                            Text("Men")
                                .tag("Men")
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading) {
                        Text("I'm interested in...")
                            .font(.subheadline)
                        //.foregroundColor(.secondary)
                        Picker("I'm interested in...", selection: $viewModel.currentUser.genderInterestedIn) {
                            Text("Women")
                                .tag("Women")
                            Text("Men")
                                .tag("Men")
                            Text("Everyone")
                                .tag("Everyone")
                        }
                        .pickerStyle(.segmented)
                    }
                }
                Section("Advanced Filter") {
                    if unlockManager.currentUser.fullVersionUnlocked {
                        ForEach(0..<10) { number in
                            HStack {
                                Text("Filter \(number)")
                                Spacer()
                                Button {

                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    } else {
                        Button {
                            showingUnlockScreen = true
                        } label: {
                            Label("Unlock full features", systemImage: "lock")
                        }
                    }
                }
                Button {
                    viewModel.deleteUser()
                } label: {
                    Label("Delete Account", systemImage: "xmark.bin")
                }
                .sheet(isPresented: $showingUnlockScreen) {
                    UnlockView()
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {

                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingLogInView) {
                LoginView()
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UnlockManager(currentUser: User.example))
    }
}

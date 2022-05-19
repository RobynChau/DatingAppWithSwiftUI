//
//  SettingView.swift
//  Dating_App
//
//  Created by Robyn Chau on 19/04/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    @ObservedObject var viewModel = SettingsView.ViewModel()

    let advancedFilterOptions = ["kidsOptions", "smokingOptions", "drinkingOptions", "relationshipTypes", "religions", "educationLevels", "jobTitle", ]

    static let tag: String? = "Settings"
    var body: some View {
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

                Section("Dating Location") {
                    Button {
                        Task {
                            viewModel.locationFetcher.start()
                            await viewModel.convertLocation()
                            print(viewModel.currentUser.locationName)
                        }
                    } label: {
                        Label("\(viewModel.currentUser.locationName), \(viewModel.currentUser.countryName)", systemImage: "arrow.clockwise")
                    }
                }

                Section("Advanced Filter") {
                    if viewModel.currentUser.fullVersionUnlocked {
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
                            viewModel.showingUnlockScreen = true
                        } label: {
                            Label("Unlock full features", systemImage: "lock")
                        }
                    }
                }
                Button(role: .destructive) {
                    viewModel.deleteUser()
                } label: {
                    Label("Delete Account", systemImage: "xmark.bin")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingLogInView) {
                LoginView()
            }
            .sheet(isPresented: $viewModel.showingUnlockScreen) {
                UnlockView()
            }
        }
}

struct DraftSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UnlockManager(currentUser: User.example))
    }
}

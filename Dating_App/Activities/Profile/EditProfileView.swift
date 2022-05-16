//
//  SetupView.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import SwiftUI
import CoreLocation

struct EditProfileView: View {

    @ObservedObject var viewModel = ViewModel()
    @State var isActive : Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationView {
            Form {
                photosSection

                introSection

                basicInformationSection

                workAndEducationSection

                lifeStyleSection

                beliefsSection

                hobbiesAndInterestsSection
            }
            .navigationTitle("Set Up")
            .onAppear {
                viewModel.locationFetcher.start()
            }
            .toolbar {
                Button("Save") {
                    Task {
                        viewModel.save()
                        viewModel.updateUser()
                    }
                }
            }
            .alert(viewModel.messageTitle, isPresented: $viewModel.showingMessage) {
                Button("Check Settings") {
                    showAppSettings()
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.messageContent)
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker){
            ImagePicker(image: $viewModel.uiImages[viewModel.imageIndex])
        }
        .onlyStackNavigationView()
    }
    
    var photosSection: some View {
        Section("Photos") {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<6) { index in
                        Button {
                            viewModel.imageIndex = index
                            viewModel.showingImagePicker = true
                        } label: {
                            if viewModel.uiImages[index] != nil {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: viewModel.uiImages[index]!)
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .frame(width: 100, height: 110)
                                        .allowsHitTesting(false)
                                    Button {
                                        viewModel.uiImages[index] = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .background(Circle().foregroundColor(.black))
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                    }
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .frame(width: 100, height: 110)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    var introSection: some View {
        Section("Your Intro") {
            ZStack(alignment: .leading) {
                if viewModel.currentUser.wrappedIntro.isEmpty {
                    Text("Describe yourself in a few words")
                        .foregroundColor(.secondary)
                        .padding(.leading, 3)
                        .disabled(true)
                }
                TextEditor(text: $viewModel.currentUser.intro.toUnwrapped(defaultValue: ""))
            }
        }
    }

    var basicInformationSection: some View {
        Section("Your Basics") {
            Label {
                TextField("Full Name", text: $viewModel.currentUser.name)
            } icon: {
                Image(systemName: Constants.icons["name"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)

            Label {
                Text("\(viewModel.currentUser.age) years old")
            } icon: {
                Image(systemName: Constants.icons["age"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)

            Label {
                TextField("Height (cm)", value: $viewModel.currentUser.height, format: .number)
                    .keyboardType(.numberPad)
            } icon: {
                Image(systemName: Constants.icons["height"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)

            Label {
                NavigationLink {
                    DatingLocationView(location: CLLocationCoordinate2D(latitude: viewModel.currentUser.latitude, longitude: viewModel.currentUser.longitude))
                } label: {
                    VStack(alignment: .leading) {
                        Text("Dating Location")
                        Text("\(viewModel.currentUser.locationName), \(viewModel.currentUser.countryName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } icon: {
                Image(systemName: Constants.icons["location"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)

            Label {
                NavigationLink(destination: GenderPicker(gender: $viewModel.currentUser.genderIdentity, rootIsActive: self.$isActive, showingGender: $viewModel.currentUser.showingGender, isOtherGenders: false), isActive: self.$isActive) {
                    VStack(alignment: .leading) {
                        Text("Gender Identity")
                        if !viewModel.currentUser.genderIdentity.isEmpty {
                            Text(viewModel.currentUser.genderIdentity)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } icon: {
                Image(systemName: Constants.icons["gender"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)

            Label {
                NavigationLink {
                    LookingForPicker(types: $viewModel.currentUser.relationshipTypes.toUnwrapped(defaultValue: []))
                } label: {
                    VStack(alignment: .leading) {
                        Text("Looking For")
                        if !viewModel.currentUser.wrappedRelationshipTypes.isEmpty {
                            Text(viewModel.currentUser.wrappedRelationshipTypes.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } icon: {
                Image(systemName: Constants.icons["lookingFor"]!)
                    .foregroundColor(.primary)
                    .overlay(Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary.opacity(0.2))
                    )
            }
            .padding(.vertical, 10)
        }
    }

    var workAndEducationSection: some View {
        Section("Your Work and Education") {
            NavigationLink {
                OccupationPicker(occupationTitle: $viewModel.currentUser.jobTitle.toUnwrapped(defaultValue: ""))
            } label: {
                if viewModel.currentUser.wrappedJobTitle == "" {
                    Label("Add Job Title", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(viewModel.currentUser.wrappedJobTitle, systemImage: Constants.icons["job"]!)
                        .foregroundColor(.primary)
                }
            }

            NavigationLink {
                LifestylePicker(navigationTitle: "Education Level", choice: $viewModel.currentUser.educationLevel.toUnwrapped(defaultValue: 0), options: Constants.educationLevels)
            } label: {
                if viewModel.currentUser.wrappedEducationLevel == 0 {
                    Label("Add Education Level", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(Constants.educationLevels[viewModel.currentUser.wrappedEducationLevel], systemImage: Constants.icons["education"]!)
                        .foregroundColor(.primary)
                }
            }
            if viewModel.currentUser.educationLevel == Constants.educationLevels.firstIndex(of: "College Degree")! {
                NavigationLink {
                    EducationPicker(university: $viewModel.currentUser.universityName.toUnwrapped(defaultValue: ""))
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Education")
                            if !viewModel.currentUser.wrappedUniversityName.isEmpty {
                                Text(viewModel.currentUser.wrappedUniversityName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } icon: {
                        Image(systemName: Constants.icons["education"]!)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    var lifeStyleSection: some View {
        Section("Your Lifestyle") {
            NavigationLink {
                LifestylePicker(navigationTitle: "Your Kids", choice: $viewModel.currentUser.kidsNumber.toUnwrapped(defaultValue: 0), options: Constants.kidsOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Kids")
                        if viewModel.currentUser.wrappedKidsNumber != 0 {
                            Text(Constants.kidsOptions[viewModel.currentUser.wrappedKidsNumber])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: Constants.icons["kids"]!)
                        .foregroundColor(.primary)
                }
            }

            NavigationLink {
                LifestylePicker(navigationTitle: "Your Smoking", choice: $viewModel.currentUser.smokingHabit.toUnwrapped(defaultValue: 0), options: Constants.smokingOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Smoking")
                        if viewModel.currentUser.wrappedSmokingHabit != 0 {
                            Text(Constants.smokingOptions[viewModel.currentUser.wrappedSmokingHabit])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: Constants.icons["smoking"]!)
                        .foregroundColor(.primary)

                }
            }

            NavigationLink {
                LifestylePicker(navigationTitle: "Your Drinking", choice: $viewModel.currentUser.drinkingHabit.toUnwrapped(defaultValue: 0), options: Constants.drinkingOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Drinking")
                        if viewModel.currentUser.wrappedDrinkingHabit != 0 {
                            Text(Constants.drinkingOptions[viewModel.currentUser.wrappedDrinkingHabit])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: Constants.icons["drinking"]!)
                        .foregroundColor(.primary)
                }
            }
        }
    }

    var beliefsSection: some View {
        Section("Your Beliefs") {
            NavigationLink {
                LifestylePicker(navigationTitle: "Religious Views", choice: $viewModel.currentUser.religion.toUnwrapped(defaultValue: 0), options: Constants.religions)
            } label: {
                if viewModel.currentUser.wrappedReligion == 0 {
                    Label("Add Religion", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(Constants.religions[viewModel.currentUser.wrappedReligion], systemImage: Constants.icons["religion"]!)
                        .foregroundColor(.primary)
                }
            }
        }
    }

    var hobbiesAndInterestsSection: some View {
        Section("Your Hobbies and Interests") {
            Button {

            } label: {
                Label("Add Hobbies", systemImage: Constants.icons["plus"]!)
            }
        }
    }

    func showAppSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}

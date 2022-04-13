//
//  SetupView.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import SwiftUI
import CoreLocation

struct EditProfileView: View {
    @ObservedObject var users: Users
    let currentUser: User

    @State private var name = ""
    @State private var age = 0
    @State private var showingGender = true
    @State private var gender = ""
    @State private var height = 0
    @State private var intro = ""
    @State private var longitude: Double = 0.0
    @State private var latitude: Double = 0.0
    @State private var locationName = ""
    @State private var countryName = ""
    @State private var lookingFor = [String]()
    @State private var uiImages = [UIImage?].init(repeating: nil, count: 9)
    @State private var imageIndex = 0

    @State private var kidsNumber = 0
    @State private var smokingHabit = 0
    @State private var drinkingHabit = 0
    @State private var religion = 0
    @State private var educationLevel = 0

    @State private var universityName = ""
    @State private var jobTitle = ""

    private let locationFetcher = LocationFetcher()

    @State var isActive : Bool = false
    @State private var showingDatingLocationView = false

    @State private var messageTitle = ""
    @State private var messageContent = ""
    @State private var showingMessage = false

    @State private var showingImagePicker = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    init(users: Users, currentUser: User) {
        self.currentUser = currentUser
        self.users = users
        _name = State(wrappedValue: currentUser.name)
        _age = State(wrappedValue: currentUser.age)
        _showingGender = State(wrappedValue: currentUser.showingGender)
        _gender = State(wrappedValue: currentUser.gender)
        _height = State(wrappedValue: currentUser.height ?? 0)
        _intro = State(wrappedValue: currentUser.intro ?? "")
        _longitude = State(wrappedValue: currentUser.longitude)
        _latitude = State(wrappedValue: currentUser.latitude)
        _locationName = State(wrappedValue: currentUser.locationName)
        _countryName = State(wrappedValue: currentUser.country)
        _lookingFor = State(wrappedValue: currentUser.lookingFor ?? [])
        _uiImages = State(wrappedValue: currentUser.uiImages)
        _kidsNumber = State(wrappedValue: currentUser.kidsNumber ?? 0)
        _smokingHabit = State(wrappedValue: currentUser.smokingHabit ?? 0)
        _drinkingHabit = State(wrappedValue: currentUser.drinkingHabit ?? 0)
        _religion = State(wrappedValue: currentUser.religion ?? 0)
        _educationLevel = State(wrappedValue: currentUser.educationLevel ?? 0)
        _universityName = State(wrappedValue: currentUser.universityName ?? "")
        _jobTitle = State(wrappedValue: currentUser.jobTitle ?? "")
    }

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
                locationFetcher.start()
            }
            .toolbar {
                Button("Save") {
                    Task {
                        await sendUser(for: save())
                    }
                }
            }
            .alert(messageTitle, isPresented: $showingMessage) {
                Button("Check Settings") {
                    showAppSettings()
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text(messageContent)
            }
        }
        .sheet(isPresented: $showingImagePicker){
            ImagePicker(image: $uiImages[imageIndex])
        }
        .onlyStackNavigationView()
    }
    
    var photosSection: some View {
        Section("Photos") {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<9) { index in
                        Button {
                            imageIndex = index
                            showingImagePicker = true
                        } label: {
                            if uiImages[index] != nil {
                                Image(uiImage: uiImages[index]!)
                                    .resizable()
                                    .frame(width: 100, height: 110)
                            } else {
                                RoundedRectangle(cornerRadius: 5)
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
                if intro.isEmpty {
                    Text("Describe yourself in a few words")
                        .foregroundColor(.secondary)
                        .padding(.leading, 3)
                        .disabled(true)
                }
                TextEditor(text: $intro)
            }
        }
    }

    var basicInformationSection: some View {
        Section("Your Basics") {
            Label {
                TextField("Full Name", text: $name)
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
                TextField("Age", value: $age, formatter: Formatter.emptyTextField)
                    .keyboardType(.numberPad)
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
                TextField("Height (cm)", value: $height, formatter: Formatter.emptyTextField)
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

            Group {
                if showingDatingLocationView == false {
                    Button {
                        locationFetcher.start()
                        getLatitudeAndLongitude()
                        showingDatingLocationView = true
                        Task {
                            let placeMarks = await getPlace(for: CLLocation(latitude: latitude, longitude: longitude))
                            if let placeMarks = placeMarks {
                                if let country = placeMarks[0].country {
                                    self.countryName = country
                                }
                                if let state = placeMarks[0].administrativeArea {
                                    self.locationName = state
                                }
                            }
                        }
                    } label: {
                        Label {
                            Text("Dating Location \(locationName), \(countryName)")
                        } icon: {
                            Image(systemName: Constants.icons["lookingFor"]!)
                                .foregroundColor(.primary)
                                .overlay(Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.secondary.opacity(0.2))
                                )
                        }
                    }
                } else {
                    NavigationLink(isActive: $showingDatingLocationView) {
                        DatingLocationView(location: locationFetcher.lastKnownLocation)
                    } label: {
                        Label {
                            Text("Dating Location \(locationName), \(countryName)")
                        } icon: {
                            Image(systemName: Constants.icons["lookingFor"]!)
                                .foregroundColor(.primary)
                                .overlay(Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.secondary.opacity(0.2))
                                )
                        }
                    }
                }
            }
            Label {
                NavigationLink(destination: GenderPicker(gender: $gender, rootIsActive: self.$isActive, showingGender: self.$showingGender, isOtherGenders: false), isActive: self.$isActive) {
                    VStack(alignment: .leading) {
                        Text("Gender Identity")
                        if !gender.isEmpty {
                            Text(gender)
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
                    LookingForPicker(types: $lookingFor)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Looking For")
                        if !lookingFor.isEmpty {
                            Text(lookingFor.joined(separator: ", "))
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
                OccupationPicker(occupationTitle: $jobTitle)
            } label: {
                if jobTitle == "" {
                    Label("Add Job Title", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(jobTitle, systemImage: Constants.icons["job"]!)
                        .foregroundColor(.primary)
                }
            }

            NavigationLink {
                LifestylePicker(navigationTitle: "Education Level", choice: $educationLevel, options: Constants.educationLevels)
            } label: {
                if educationLevel == 0 {
                    Label("Add Education Level", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(Constants.educationLevels[educationLevel], systemImage: Constants.icons["education"]!)
                        .foregroundColor(.primary)
                }
            }
            if educationLevel == Constants.educationLevels.firstIndex(of: "College Degree")! {
                NavigationLink {
                    EducationPicker(university: $universityName)
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Education")
                            if !universityName.isEmpty {
                                Text(universityName)
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
                LifestylePicker(navigationTitle: "Your Kids", choice: $kidsNumber, options: Constants.kidsOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Kids")
                        if kidsNumber != 0 {
                            Text(Constants.kidsOptions[kidsNumber])
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
                LifestylePicker(navigationTitle: "Your Smoking", choice: $smokingHabit, options: Constants.smokingOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Smoking")
                        if smokingHabit != 0 {
                            Text(Constants.smokingOptions[smokingHabit])
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
                LifestylePicker(navigationTitle: "Your Drinking", choice: $drinkingHabit, options: Constants.drinkingOptions)
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Your Drinking")
                        if drinkingHabit != 0 {
                            Text(Constants.drinkingOptions[drinkingHabit])
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
                LifestylePicker(navigationTitle: "Religious Views", choice: $religion, options: Constants.religions)
            } label: {
                if religion == 0 {
                    Label("Add Religion", systemImage: Constants.icons["plus"]!)
                        .foregroundColor(.primary)
                } else {
                    Label(Constants.religions[religion], systemImage: Constants.icons["religion"]!)
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

    func getLatitudeAndLongitude() {
        if let data = locationFetcher.lastKnownLocation {
            self.latitude = data.latitude
            self.longitude = data.longitude
        } else {
            messageTitle = "Failed to find location"
            messageContent = "Please allow us to use your current location and try again."
            showingMessage = true
        }
    }

    func save() async -> User {
        getLatitudeAndLongitude()
        var user = User(
            name: name,
            age: age,
            height: height == 0 ? nil : height,
            gender: gender,
            showingGender: showingGender,
            longitude: longitude,
            latitude: latitude,
            locationName: locationName,
            country: countryName,
            intro: intro.isEmpty ? nil : intro,
            lookingFor: lookingFor.isEmpty ? nil : lookingFor,
            kidsNumber: kidsNumber == 0 ? nil : kidsNumber,
            smokingHabit: smokingHabit == 0 ? nil : smokingHabit,
            drinkingHabit: drinkingHabit == 0 ? nil : drinkingHabit,
            religion: religion == 0 ? nil : religion,
            educationLevel: educationLevel == 0 ? nil : educationLevel,
            universityName: universityName == "" ? nil : universityName,
            jobTitle: jobTitle == "" ? nil : jobTitle,
            hobbies: [],
            images: []
        )
        let placeMarks = await getPlace(for: CLLocation(latitude: latitude, longitude: longitude))
        if let placeMarks = placeMarks {
            if let country = placeMarks[0].country {
                user.country = country
            }
            if let state = placeMarks[0].administrativeArea {
                user.locationName = state
            }
        }
        else {
            print("Error")
        }
        var imageDatas = [Data?]()

        for uiImage in uiImages {
            if let uiImage = uiImage {
                if let data = uiImage.jpegData(compressionQuality: 0.8) {
                    imageDatas.append(data)
                }
            } else {
                imageDatas.append(nil)
            }
        }
        user.images = imageDatas
        users.users.append(user)
        print(user)
        return user
    }

    func getPlace(for location: CLLocation) async -> [CLPlacemark]? {
        let geoCoder = CLGeocoder()
        return try! await geoCoder.reverseGeocodeLocation(location)
    }

    func sendUser(for user: User) async {
        guard let encoded = try? JSONEncoder().encode(user) else {
            messageTitle = "Failed to encode"
            messageContent = "Cannot encode user to JSON"
            showingMessage = true
            return
        }

        let url = URL(string: "https://reqres.in/api/user")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            let decodedUser = try JSONDecoder().decode(User.self, from: data)
            print(decodedUser.name)
        } catch {
            messageTitle = "Error in fetching user"
            showingMessage = true
        }
    }

    func validateInput() {

    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(users: Users(), currentUser: User.currentUser)
    }
}

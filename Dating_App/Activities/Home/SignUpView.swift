//
//  SignUpView.swift
//  Dating_App
//
//  Created by Robyn Chau on 11/04/2022.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var dateOfBirth = Date()
    @State private var name = ""
    @State private var genderIdentity = ""
    @State private var genderForMatches = ""
    @State private var showingNextStep = false
    @State private var step = 1
    @State private var showingConfirmationDialog = false
    @State private var hasChangedDateOfBirth = false
    @State private var showingGender = false
    @State private var showingImagePicker = false
    @State private var uiImages = [UIImage?].init(repeating: nil, count: 9)
    @State private var hasAddedPhoto = false
    @State private var imageIndex = 0
    @State private var longitude: Double = 0.0
    @State private var latitude: Double = 0.0
    @State private var locationName = ""
    @State private var countryName = ""

    @State private var messageTitle = ""
    @State private var messageContent = ""
    @State private var showingMessage = false

    private let locationFetcher = LocationFetcher()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    // @Binding var currentUser: User
    let email: String
    let password: String

    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Text("Step \(step)/6")
                    ProgressView(value: Double(step), total: 6)
                        .padding(.horizontal)
                }
                Spacer()

                Section {
                    Group {
                        switch step {
                        case 1:
                            nameStep
                        case 2:
                            dateOfBirthStep
                        case 3:
                            genderIdentityStep
                        case 4:
                            genderMatchStep
                        case 5:
                            imageStep
                        default:
                            locationStep
                        }
                    }
                }

                Spacer()
            }
            .onAppear {
                print(email)
                print(password)
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        withAnimation {
                            if step > 1 {
                                step -= 1
                            }
                        }
                    } label: {
                        if step > 1 {
                            Label("Back", systemImage: "chevron.backward")
                        } else {
                            EmptyView()
                        }
                    }
            )
        }
    }

    var nameStep: some View {
        VStack(spacing: 15) {
            Text("What do you like to be called?")
                .font(.title2)

            TextField("Your name", text: $name)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .background(.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal, 80)

            Text("This is how you’ll appear on Bumble")
                .font(.caption)
                .foregroundColor(.secondary)

            Button {
                withAnimation() {
                    step += 1
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: 100)
            }
            .buttonStyle(.borderedProminent)
            .disabled(name == "")
        }
    }

    var dateOfBirthStep: some View {
        VStack(spacing: 15) {
            Text("Hey \(name), when is your birthday?")
                .font(.title2)

            DatePicker(
                "Date of Birth",
                selection: $dateOfBirth,
                in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                displayedComponents: .date
            )
            .labelsHidden()
            .onTapGesture {
                hasChangedDateOfBirth = true
            }

            Text("You must be at least 18 years old")
                .foregroundColor(.secondary)
                .font(.caption)
            Text("Your birthday will not be shown publicly")
                .foregroundColor(.secondary)
                .font(.caption)

            Button {
                withAnimation() {
                    step += 1
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: 100)
            }
            .buttonStyle(.borderedProminent)
            .disabled(hasChangedDateOfBirth == false)
        }
    }

    var genderIdentityStep: some View {
        VStack {
            Text("How do you identify?")
                .font(.title2)
            VStack(alignment: .center) {
                if genderIdentity == "" {
                    ForEach(Constants.genders, id: \.self) { choice in
                        HStack {
                            Image(systemName: choice == genderIdentity ? "circle.fill" : "circle")
                            Text(choice)
                            Spacer()
                        }
                        .padding(10)
                        .frame(maxWidth: 270)
                        .background(.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if genderIdentity == choice {
                                genderIdentity = ""
                            } else {
                                genderIdentity = choice

                            }
                        }
                    }
                    Button("More options...") {
                        showingConfirmationDialog = true
                    }
                }
                else {
                    HStack {
                        Image(systemName: "circle.fill")
                        Text(genderIdentity)
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxWidth: 270)
                    .background(.gray.opacity(0.15))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if genderIdentity != "" {
                            genderIdentity = ""
                        }
                    }

                    Button("More options...") {
                        showingConfirmationDialog = true
                    }
                }

                Button {
                    withAnimation() {
                        step += 1
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: 100)
                }
                .buttonStyle(.borderedProminent)
                .disabled(genderIdentity == "")
            }
        }
        .confirmationDialog("Select your gender", isPresented: $showingConfirmationDialog) {
            VStack {
                ForEach(genderIdentity == "" ? Constants.broadOtherGenders : Constants.broadOtherGenders + Constants.genders, id: \.self) { choice in
                    Button {
                        genderIdentity = choice
                    } label: {
                        Text(choice)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    var genderMatchStep: some View {
        VStack {
            Text("Show me searches for...")
                .font(.title2)
            VStack(alignment: .center) {
                HStack {
                    Image(systemName: genderForMatches == "Women" ? "circle.fill" : "circle")
                    Text("Women")
                    Spacer()
                }
                .padding(10)
                .frame(maxWidth: 270)
                .background(.gray.opacity(0.15))
                .cornerRadius(10)
                .contentShape(Rectangle())
                .onTapGesture {
                    genderForMatches = "Women"
                }

                HStack {
                    Image(systemName: genderForMatches == "Men" ? "circle.fill" : "circle")
                    Text("Men")
                    Spacer()
                }
                .padding(10)
                .frame(maxWidth: 270)
                .background(.gray.opacity(0.15))
                .cornerRadius(10)
                .contentShape(Rectangle())
                .onTapGesture {
                    genderForMatches = "Men"
                }
                VStack {
                    Text("Privacy")
                        .padding(.top, 40)
                        .foregroundColor(.secondary)
                    Toggle("Display my gender identity", isOn: $showingGender)
                    Text("Turning this off means your gender identity won’t be visible on your profile")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 350)

                Button {
                    withAnimation() {
                        step += 1
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: 100)
                }
                .buttonStyle(.borderedProminent)
                .disabled(genderForMatches == "")
            }
        }
    }

    var imageStep: some View {
        VStack {
            Text("Now it’s time to upload some photos")
                .font(.title2)
            Text("Adding photos is a great way to show off more about yourself!")
                .foregroundColor(.secondary)
                .font(.caption)
                .multilineTextAlignment(.center)

            if uiImages.filter {$0 != nil}.count == 0 {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        hasAddedPhoto = true
                        showingImagePicker = true
                    }
            } else {
                VStack {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<9) { index in
                            Button {
                                imageIndex = index
                                showingImagePicker = true
                            } label: {
                                if uiImages[index] != nil {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: uiImages[index]!)
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                            .frame(width: 100, height: 110)
                                            .allowsHitTesting(false)
                                        Button {
                                            uiImages[index] = nil
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
                    .padding()
                }
            }
            Button {
                withAnimation() {
                    step += 1
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: 100)
            }
            .buttonStyle(.borderedProminent)
            .disabled(uiImages.filter {$0 != nil}.count == 0)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $uiImages[imageIndex])
        }
    }

    var locationStep: some View {
        VStack {
            Text("We need your location to show who’s nearby")
            Button {
                Task {
                if let data = locationFetcher.lastKnownLocation {
                    self.latitude = data.latitude
                    self.longitude = data.longitude
                } else {
                    messageTitle = "Failed to find location"
                    messageContent = "Please allow us to use your current location and try again."
                    showingMessage = true
                }

                let placeMarks = await getPlace(for: CLLocation(latitude: latitude, longitude: longitude))
                if let placeMarks = placeMarks {
                    if let country = placeMarks[0].country {
                        countryName = country
                    }
                    if let state = placeMarks[0].administrativeArea {
                        locationName = state
                    }
                }
                else {
                    print("Error")
                }

                save()
                //presentationMode.wrappedValue.dismiss()
            }

            } label: {
                Text("Find Location")
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            locationFetcher.start()
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

    func showAppSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }

    func getPlace(for location: CLLocation) async -> [CLPlacemark]? {
        let geoCoder = CLGeocoder()
        return try! await geoCoder.reverseGeocodeLocation(location)
    }

    func calculateAge() -> Int {
        return Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year!
    }

    func save() {
        var user = User(name: name, age: calculateAge(), gender: genderIdentity, longitude: longitude, latitude: latitude, locationName: locationName, country: countryName)
        saveImages(for: &user)

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            messageTitle = "Failed to retrieve current user"
            showingMessage = true
            return
        }

        do {
            try FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: user)
        } catch let error {
            messageTitle = "Failed to store user information"
            messageContent = "\(error.localizedDescription)"
            showingMessage = true
            return
        }
        presentationMode.wrappedValue.dismiss()
    }

    private func saveImages(for user: inout User) {
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
    }
}

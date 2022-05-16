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

    @StateObject var viewModel = ViewModel()

    @State private var showingNextStep = false
    @State private var step = 1
    @State private var showingConfirmationDialog = false
    @State private var hasChangedDateOfBirth = false
    @State private var showingImagePicker = false
    @State private var hasAddedPhoto = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

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
                            genderFilterStep
                        case 5:
                            imageStep
                        default:
                            locationStep
                        }
                    }
                }

                Spacer()
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
                            Label("Back", systemImage: Constants.icons["back"]!)
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

            TextField("Your name", text: $viewModel.name)
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
            .disabled(viewModel.name == "")
        }
    }

    var dateOfBirthStep: some View {
        VStack(spacing: 15) {
            Text("Hey \(viewModel.name), when is your birthday?")
                .font(.title2)

            DatePicker(
                "Date of Birth",
                selection: $viewModel.dateOfBirth,
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
                if viewModel.genderIdentity == "" {
                    ForEach(Constants.genders, id: \.self) { choice in
                        HStack {
                            Image(systemName: choice == viewModel.genderIdentity ? "circle.fill" : "circle")
                            Text(choice)
                            Spacer()
                        }
                        .padding(10)
                        .frame(maxWidth: 270)
                        .background(.gray.opacity(0.15))
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.genderIdentity == choice {
                                viewModel.genderIdentity = ""
                            } else {
                                viewModel.genderIdentity = choice
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
                        Text(viewModel.genderIdentity)
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxWidth: 270)
                    .background(.gray.opacity(0.15))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.genderIdentity != "" {
                            viewModel.genderIdentity = ""
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
                .disabled(viewModel.genderIdentity == "")
            }
        }
        .confirmationDialog("Select your gender", isPresented: $showingConfirmationDialog) {
            VStack {
                ForEach(viewModel.genderIdentity == "" ? Constants.broadOtherGenders : Constants.broadOtherGenders + Constants.genders, id: \.self) { choice in
                    Button {
                        viewModel.genderIdentity = choice
                    } label: {
                        Text(choice)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    var genderFilterStep: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Show me in searches for")
                    .font(.title2)

                Picker("Show me in searches for...", selection: $viewModel.genderInSearch) {
                    Text("Women")
                        .tag("Women")
                    Text("Men")
                        .tag("Men")
                }
                .pickerStyle(.segmented)
            }
            .frame(maxWidth: 350)


            VStack(alignment: .leading) {
                Text("I'm interested in...")
                    .font(.title2)

                Picker("I'm interested in...", selection: $viewModel.genderInterestedIn) {
                    Text("Women")
                        .tag("Women")
                    Text("Men")
                        .tag("Men")
                    Text("Everyone")
                        .tag("Everyone")
                }
                .pickerStyle(.segmented)
            }
            .frame(maxWidth: 350)

            VStack {
                Text("Privacy")
                    .padding(.top, 40)
                    .foregroundColor(.secondary)
                Toggle("Display my gender identity", isOn: $viewModel.showingGender)
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
            .disabled(viewModel.genderInSearch == "")

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

            if viewModel.uiImages.filter {$0 != nil}.count == 0 {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        hasAddedPhoto = true
                        showingImagePicker = true
                    }
            } else {
                VStack {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<6) { index in
                            Button {
                                viewModel.imageIndex = index
                                showingImagePicker = true
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
            .disabled(viewModel.uiImages.filter {$0 != nil}.count == 0)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.uiImages[viewModel.imageIndex])
        }
    }

    var locationStep: some View {
        VStack {
            Text("We need your location to show who’s nearby")
            Button {
                Task {
                    await viewModel.convertLocation()
                    save()
                }

            } label: {
                Text("Find Location")
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            viewModel.startLocationFetcher()
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

    func showAppSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }

    func save() {
        viewModel.save()
        try! FirebaseManager.shared.auth.signOut()
        presentationMode.wrappedValue.dismiss()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

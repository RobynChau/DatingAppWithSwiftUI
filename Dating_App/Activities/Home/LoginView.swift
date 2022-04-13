//
//  LoginView.swift
//  Dating_App
//
//  Created by Robyn Chau on 03/04/2022.
//

import SwiftUI

enum Field: Hashable {
    case email, password
}

struct LoginView: View {
    @FocusState private var focusedField: Field?
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var showingSignUpView = false
    @State private var showingHomeScreen = false

    @State private var currentUser = User(name: "", age: 0, gender: "", longitude: 0, latitude: 0, locationName: "", country: "")

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker(selection: $isLoginMode, label: Text("Login Picker")) {
                    Text("Login")
                        .tag(true)
                    Text("Create Account")
                        .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Section {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                            //.border(Color.red,
                                    //width: (focusedField == .email && !validEmail() ? 2 : 0))
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                    }
                    .padding(12)
                    .background(.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding([.horizontal, .bottom], 12)

                    Button {
                        focusedField = nil
                        handleAction()
                    } label: {
                        Text(isLoginMode ? "Login" : "Create Account")
                            .frame(maxWidth: 300)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.accentColor)
                }
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
            }
            .sheet(isPresented: $showingSignUpView) {
                SignUpView(email: email, password: "\(password)")
            }
            .fullScreenCover(isPresented: $showingHomeScreen) {
                MainTabView(currentUser: $currentUser)
            }
            .onChange(of: isLoginMode) { _ in
                email = ""
                password = ""
                focusedField = nil
            }
            .toolbar {
                Button("Print") {
                    print(currentUser)
                }
            }
        }
    }

    func handleAction() {
        guard validEmail() else {
            focusedField = .email
            alertTitle = "Invalid Email"
            alertMessage = "Your email is invalid. Please try again."
            showingAlert = true
            return
        }
        if isLoginMode {
            handleLogin()
        } else {
            handleSignUp()
        }
    }

    func handleLogin() {
        loginUser()
        showingHomeScreen = true
    }

    func handleSignUp() {
        createUser()
        showingSignUpView = true
    }

    func validEmail() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        return email.range(
            of: emailPattern,
            options: .regularExpression
        ) != nil
    }

    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertTitle = "Failed to log in."
                alertMessage = error.localizedDescription
                showingAlert.toggle()
                return
            }

        }
        fetchCurrentUser()
    }

    func fetchCurrentUser() {

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: User.self) { result in
            switch result {
            case .success(let retrieved):
                currentUser = retrieved
            case.failure(let error):
                alertTitle = "Failed to get fetch current user"
                alertMessage = "\(error.localizedDescription)"
                showingAlert = true
            }

        }
    }

    private func createUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertTitle = "Failed to create account."
                alertMessage = error.localizedDescription
                showingAlert = true
                return
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


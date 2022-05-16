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
    @EnvironmentObject var unlockManager: UnlockManager

    @FocusState private var focusedField: Field?
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var uid = ""

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @ObservedObject var viewModel = ViewModel()

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
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .cancel())
            }
            .sheet(isPresented: $viewModel.showingSignUpView) {
                SignUpView()
            }
            .fullScreenCover(isPresented: $viewModel.isUserCurrentlyLoggedIn, onDismiss: nil) {
                MainTabView()
            }
            .onChange(of: isLoginMode) { _ in
                email = ""
                password = ""
                focusedField = nil
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
            viewModel.loginUser(email: email, password: password, unlockManger: unlockManager)
        } else {
            viewModel.createUser(email: email, password: password)
        }
    }

    func validEmail() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        return email.range(
            of: emailPattern,
            options: .regularExpression
        ) != nil
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UnlockManager(currentUser: User.example))
    }
}


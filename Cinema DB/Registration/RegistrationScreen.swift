//
//  RegistrationScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 31.12.2023.
//

import SwiftUI
import Logger
import FirebaseAuth

@MainActor
struct RegistrationScreen: View {
    
    enum Focus: Hashable {
        case email
        case password
        case repeatPassword
    }
    
    @Environment(\.navigationRouter) private var router
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var email: InputState = .init {
        NonEmpty()
        WrongFormatValidator(regex: Constants.Regexes.emailRegex)
            .mapError { _ in
                throw FieldErrors.emailWrongFormat
            }
    }
    
    @State private var password: InputState = .init {
        WrongFormatValidator(regex: Constants.Regexes.passwordRegex)
            .mapError { _ in
                throw FieldErrors.passwordWrongFormat
            }
    }
    
    @State private var repeatedPassword: InputState = .init {
        NonEmpty()
    }
    
    @FocusState private var focusState: Focus?
    
    private var isRegistrationButtonEnable: Bool {
        guard !email.text.isEmpty,
              !password.text.isEmpty,
              !repeatedPassword.text.isEmpty else {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Text("Haven't account? ")
                            .font(.custom("8bitOperatorPlus-Bold", size: 22))
                            .multilineTextAlignment(.center)
                        
                        Text("Let's Join Us !")
                            .font(.custom("TheyPerished", size: 28))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            InputView(placeholder: "Enter mail", text: $email.text)
                                .withInputStyle(title: "Mail", error: email.errorMessage)
                                .uiKeyboardType(.emailAddress)
                                .uiTextColor(.cinemaBlack)
                                .uiOnBeginEditing {
                                    email.clearError()
                                }
                                .uiSubmitAction {
                                    focusState = .password
                                }
                                .focused($focusState, equals: .email)
                            
                            SecureInputView(placeholder: "Enter password", text: $password.text)
                                .withInputStyle(title: "Password", error: password.errorMessage)
                                .uiKeyboardType(.default)
                                .uiReturnKeyType(.done)
                                .uiOnBeginEditing {
                                    password.clearError()
                                }
                                .uiSubmitAction {
                                    focusState = .repeatPassword
                                }
                                .focused($focusState, equals: .password)
                            
                            SecureInputView(placeholder: "Repeat password", text: $repeatedPassword.text)
                                .withInputStyle(title: "Password", error: password.errorMessage)
                                .uiKeyboardType(.default)
                                .uiReturnKeyType(.done)
                                .uiOnBeginEditing {
                                    password.clearError()
                                }
                                .uiSubmitAction {
                                    focusState = nil
                                    registrationAction()
                                }
                                .focused($focusState, equals: .repeatPassword)
                        }
                        .padding(.all, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .foregroundColor(.lightOrange)
                    )
                    
                    Spacer()
                    
                    Button {
                        registrationAction()
                    } label: {
                        Text("Registration")
                            .strokedButtonTitle()
                    }
                    .buttonStyle(.plain)
                    .disabled(isRegistrationButtonEnable)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .uiReturnKeyType(.next)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .lightBlue, .lightOrange]), startPoint: .top, endPoint: .bottom).opacity(0.7)
        )
    }
    
    private func registrationAction() {
        email.validate()
        password.validate()
        password.text != repeatedPassword.text ? repeatedPassword.error = FieldErrors.passwordDoesNotMatch : nil
        
        guard email.isValid,
              password.isValid,
              repeatedPassword.isValid,
              password.text == repeatedPassword.text else {
            return
        }
        
        Task {
            do {
                _ = try await authManager.signUpWith(email: email.text, password: password.text)
                await MainActor.run {
                    router.push(destination: HomePage(), replaceStack: true)
                }
                
            } catch {
                Log(error: error)
            }
        }
    }
}

#Preview {
    NavigationControllerView{
        RegistrationScreen()
    }
}

private enum FieldErrors: Error, LocalizedError {
    case emailWrongFormat
    case passwordWrongFormat
    case passwordDoesNotMatch
    
    var errorDescription: String? {
        switch self {
        case .emailWrongFormat:
            return "Wrong format"
        case .passwordWrongFormat:
            return "Inwalid password"
        case .passwordDoesNotMatch:
            return "Password dosen't match"
        }
    }
}

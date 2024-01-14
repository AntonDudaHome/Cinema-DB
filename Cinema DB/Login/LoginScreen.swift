//
//  LoginScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 31.12.2023.
//

import SwiftUI
import Logger
import FirebaseAuth


@MainActor
struct LoginScreen: View{
    
    enum Focus {
        case email
        case password
    }
    
    @Environment(\.navigationRouter) private var router
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var email: InputState = .init {
        NonEmpty()
        WrongFormatValidator(regex: Constants.Regexes.emailRegex)
            .mapError { _ in
                throw EmailError.emailWrongFormat
            }
    }
    
    @State private var password: InputState = .init {
        NonEmpty()
    }
    
    @FocusState private var focusState: Focus?
   
    private var isButtonEnable: Bool {
        guard !email.text.isEmpty,
              !password.text.isEmpty else {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Text("Already have an account?")
                            .font(.custom("8bitOperatorPlus-Bold", size: 22))
                        
                        Text("Let's go fun !")
                            .font(.custom("TheyPerished", size: 28))
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
                                    focusState = nil
                                    loginAction()
                                }
                                .focused($focusState, equals: .password)
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 32)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .foregroundColor(.lightBlue)
                            .opacity(0.85)
                    )
                    
                    Spacer()
                    
                    Button {
                        loginAction()
                    } label: {
                        Text("Login")
                            .strokedButtonTitle()
                    }
                    .buttonStyle(.plain)
                    .disabled(isButtonEnable)
                }
            }
            .padding(.horizontal, 24)
        }
        .uiReturnKeyType(.next)
        .background(alignment: .top) {
            Image("login_illustration")
                .resizable()
                .scaledToFit()
                .opacity(0.8)
                
        }
    }
    
    private func loginAction() {
        email.validate()
        password.validate()
        
        guard email.isValid, password.isValid else {
            return
        }
        
        Task {
            do {
                _ = try await authManager.signInWith(email: email.text, password: password.text)
                
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
    NavigationControllerView {
        LoginScreen()
    }
}

private enum EmailError: Error, LocalizedError {
    case emailWrongFormat

    var errorDescription: String? {
        switch self {
        case .emailWrongFormat:
            return "Email is incorrect"
        }
    }
}

//
//  LoginScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 31.12.2023.
//

import SwiftUI

private enum EmailError: Error, LocalizedError {
    case emailWrongFormat

    var errorDescription: String? {
        switch self {
        case .emailWrongFormat:
            return "Email is incorrect"
        }
    }
}
@MainActor
struct LoginScreen: View {
    enum Focus {
        case email
        case password
    }
    
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
            return false
        }
        return true
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    VStack {
                        Text("Already have an account? \n Let's go fun!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .bold()
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 32) {
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
                .scaledToFill()
                .opacity(0.8)
                .ignoresSafeArea(edges: .all)
        }
    }
    
    private func loginAction() {
        email.validate()
        password.validate()
        
        guard email.isValid, password.isValid else {
            return
        }
        
        print("Login action st")
    }
}



#Preview {
    NavigationView {
        LoginScreen()
    }
}

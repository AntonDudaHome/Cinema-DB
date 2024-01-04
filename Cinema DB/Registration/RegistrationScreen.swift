//
//  RegistrationScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 31.12.2023.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    private var isRegistrationButtonEnable: Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else { return true }
        return false
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    VStack {
                        Text("Haven't account? \n Let's Join Us!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .bold()
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 32) {
                            TextField("Email:", text: $email)
                                .textFieldStyle(.plain)
                                .keyboardType(.emailAddress)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(.plain)
                                .keyboardType(.default)
                            
                            SecureField("Confirm password", text: $confirmPassword)
                                .textFieldStyle(.plain)
                                .keyboardType(.default)
                        }
                        .padding(.all, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .foregroundColor(.lightOrange)
                    )
                    
                    Spacer()
                    
                    Button {
                        print("start register")
                    } label: {
                        Text("Registration")
                            .fillWidth()
                    }
                    .buttonStyle(StrokedButtonStyle.custom(.cinemaBlack))
                    .disabled(isRegistrationButtonEnable)
                }
            }
            .padding(.horizontal, 24)
        }
        .background(alignment: .top) {
            Image("register_illustration")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .ignoresSafeArea(edges: .all)
        }
    }
    
    private func registrationAction() {
        
    }
}

#Preview {
    RegistrationScreen()
}

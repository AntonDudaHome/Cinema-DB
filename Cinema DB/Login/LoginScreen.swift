//
//  LoginScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 31.12.2023.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
   
    private var isButtonEnable: Bool {
        guard !email.isEmpty, !password.isEmpty else { return true }
        return false
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
                            TextField("Email:", text: $email)
                                .textFieldStyle(.plain)
                                .keyboardType(.emailAddress)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(.plain)
                                .keyboardType(.default)
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
                            .fillWidth()
                    }
                    .buttonStyle(StrokedButtonStyle.custom(.cinemaBlack))
                    .disabled(isButtonEnable)
                }
            }
            .padding(.horizontal, 24)
        }
        .background(alignment: .top) {
            Image("login_illustration")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .ignoresSafeArea(edges: .all)
        }
    }
}



#Preview {
    NavigationView {
        LoginScreen()
    }
}

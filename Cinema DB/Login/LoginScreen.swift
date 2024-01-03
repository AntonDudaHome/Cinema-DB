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
    
    var body: some View {
        
        VStack {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    VStack {
                        Text("Have account? Let's login!")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 24) {
                            TextField("Email:", text: $email)
                            
                            SecureField("Password", text: $password)
                        }
                        .padding(.all, 16)
                    }
                    .background(Color.white)
                    .opacity(0.7)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Login")
                            .fillWidth()
                    }
                    .buttonStyle(StrokedButtonStyle.custom(.black))
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

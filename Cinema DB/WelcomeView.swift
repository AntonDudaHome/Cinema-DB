//
//  WelcomeView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 20.12.2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 16) {
                    Spacer()
                    VStack(alignment: .center, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Welcome to Cinema DB")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            
                            Text("Loren ipsom descript")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            NavigationLink {
                                LoginScreen()
                            } label: {
                                Text("Log In")
                                    .fillWidth()
                            }
                            .buttonStyle(StrokedButtonStyle.custom(.mint))

                            Text("or")
                            
                            NavigationLink {
                                RegistrationScreen()
                            } label: {
                                Text("Register")
                                    .fillWidth()
                            }
                            .buttonStyle(StrokedButtonStyle.custom(.indigo))
                        }
                        
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(alignment: .top) {
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .top)
            }
        }
    }
}

#if DEBUG
#Preview {
    WelcomeView()
}
#endif

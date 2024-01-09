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
                                .font(.custom("TheyPerished", size: 28))
                                .foregroundStyle(Color.cinemaBlack)
                            
                            Text("Loren ipsom descript")
                                .font(.custom("8bitOperatorPlus-Regular", size: 16))
                                .foregroundColor(Color.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            NavigationLink {
                                LoginScreen()
                            } label: {
                                Text("Log In")
                                    .strokedButtonTitle()
                            }
                            .buttonStyle(.plain)

                            Text("or")
                                .font(.custom("8bitOperatorPlus-Bold", size: 14))
                                .foregroundStyle(Color.cinemaBlack)
                            
                            NavigationLink {
                                RegistrationScreen()
                            } label: {
                                Text("Register")
                                    .strokedButtonTitle()
                            }
                            .buttonStyle(.plain)
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

//
//  WelcomeView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 20.12.2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.navigationRouter) private var router
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Spacer()
                VStack(alignment: .center, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Welcome to Cinema DB")
                            .font(.custom("TheyPerished", size: 28))
                            .foregroundStyle(Color.cinemaBlack)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur velit tellus, facilisis eu tellus ac, vestibulum finibus nisi.")
                            .font(.custom("8bitOperatorPlus-Regular", size: 16))
                            .foregroundColor(Color.gray)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        Button {
                            router.push(destination: LoginScreen())
                        } label: {
                            Text("Log In")
                                .strokedButtonTitle()
                        }
                        .buttonStyle(.plain)
                        
                        Text("or")
                            .font(.custom("8bitOperatorPlus-Bold", size: 14))
                            .foregroundStyle(Color.cinemaBlack)
                        
                        Button {
                            router.push(destination: RegistrationScreen())
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
        .bpNavigationBarHidden(true)
        .background(alignment: .top) {
            Image("background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .top)
        }
    }
}

#if DEBUG
#Preview {
    NavigationControllerView {
        WelcomeView()
    }
}
#endif

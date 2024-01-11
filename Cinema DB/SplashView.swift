//
//  SplashView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("splash_image")
                .resizable()
                .scaledToFill()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}

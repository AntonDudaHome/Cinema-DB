//
//  ButtonModifier.swift
//  Cinema DB
//
//  Created by Anton.Duda on 09.01.2024.
//

import SwiftUI

struct ButtonModifier: ViewModifier {

func body(content: Content) -> some View {
    content
        .font(.custom("8bitOperatorPlus-Bold", size: 18))
        .frame(maxWidth: .infinity)
        .foregroundColor(.cinemaBlack)
        .padding(.vertical, 15)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(.clear)
                RoundedRectangle(cornerRadius: 40)
                    .strokeBorder(Color.purple, lineWidth: 1.2)
            }
        }
}
}

public extension View {
    
    func strokedButtonTitle() -> some View {
        self.modifier(ButtonModifier())
    }
}

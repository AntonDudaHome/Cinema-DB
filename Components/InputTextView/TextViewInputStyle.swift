//
//  TextViewInputStyle.swift
//  Cinema DB
//
//  Created by Anton.Duda on 17.01.2024.
//

import SwiftUI

public struct InputStyle: ViewModifier {

    let title: String?
    let error: String?
    let subtitle: String?


    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .padding(.horizontal, 8)
                    .font(.custom("8bitOperatorPlus-Bold", size: 14))
                    .foregroundColor(.white)
                    .colorMultiply(error == nil ? .cinemaBlack : .red)
            }

            content
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.clear)
                .cornerRadius(16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(error == nil ? .black : .red, lineWidth: 1.5)
                }

            if let subtitleValue {
                Text(subtitleValue)
                    .padding(.horizontal, 8)
                    .font(error == nil ? .custom("8bitOperatorPlus-Regular", size: 14) : .custom("8bitOperatorPlus-Regular", size: 12))
                    .foregroundColor(.white)
                    .colorMultiply(error == nil ? .cinemaBlack : .red)
                    .transition(.opacity.combined(with: .offset(y: -16)))
                    .id(subtitleValue)
                    .zIndex(-1)
            }
        }
    }
    
    private var subtitleValue: String? {
        if let error {
            return error
        }
        return subtitle
    }
}

public extension View {

    func withInputStyle(title: String?, error: String?, subtitle: String? = nil) -> some View {
        self.modifier(InputStyle(title: title, error: error, subtitle: subtitle))
    }
}


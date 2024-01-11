//
//  InputViews.swift
//  
//
//  Created by Sergiy Loza on 19.10.2023.
//

import SwiftUI

/// Default input view to be used in app
public struct InputView: View {

    let placeholder: String
    @Binding var text: String

    @Environment(\.isEnabled) private var enabled

    public init(placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        UIKitTextField(placeholder: placeholder, text: $text)
            .uiTextColor(.cinemaBlack)
            .uiTextFont(UIFont(name: "8bitOperatorPlus-Regular", size: 14))
            .uiTextPlaceholderAttributes(.init(color: .darkGray,
                                               font: UIFont(name: "8bitOperatorPlus-Bold", size: 14)!))
            .opacity(enabled ? 1.0 : 0.3)
    }
}

/// Secure input view to be used in app
public struct SecureInputView: View {

    let placeholder: String
    @Binding var text: String

    @State private var isSecure: Bool = true
    @Environment(\.isEnabled) private var enabled

    public init(placeholder: String = "", text: Binding<String>, focus: Bool = false) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        HStack {
            UIKitTextField(placeholder: placeholder, isSecure: isSecure, text: $text)
                .uiTextColor(.cinemaBlack)
                .uiTextFont(UIFont(name: "8bitOperatorPlus-Regular", size: 14))
                .uiTextPlaceholderAttributes(.init(color: .darkGray,
                                                   font: UIFont(name: "8bitOperatorPlus-Bold", size: 14)!))
            Spacer()
            Button {
                withAnimation(.spring()) {
                    isSecure.toggle()
                }
            } label: {
                if isSecure {
                    Image("close_eye")
                        .renderingMode(.original)
                } else {
                    Image("open_eye")
                        .renderingMode(.original)
                }
            }
        }
        .opacity(enabled ? 1.0 : 0.3)
    }
}

//
//  TextFieldView.swift
//  CinemaBase
//
//  Created by Anton.Duda on 18.10.2023.
//

import SwiftUI

public struct TextFieldView: View {
    @State private var inputText: String = ""
    
    var topText: String
    var textColor: UIColor
    
    init(topText: String = "Text",
         textColor: UIColor = .black) {
        self.topText = topText
        self.textColor = textColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Enter Email")
                .font(.footnote)
                .foregroundStyle(Color(textColor))
            TextField("Email", text: $inputText)
                .frame(height: 52)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

public struct SecureTextFieldView: View {
    @State private var secureText: String = ""
    
    var topText: String
    var textColor: UIColor
    
    init(topText: String = "Text",
         textColor: UIColor = .black) {
        self.topText = topText
        self.textColor = textColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(topText)
                .font(.footnote)
                .foregroundStyle(Color(textColor))
            SecureField("Password", text: $secureText)
                .frame(height: 48)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

#if DEBUG
#Preview {
    VStack {
        TextFieldView()
            .padding(.horizontal)
        SecureTextFieldView()
            .padding(.horizontal)
    }
}
#endif

//
//  ButtonsComponentView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 21.12.2023.
//

import SwiftUI

public struct FilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var enabled
    
    var filledColor: Color
    
    init(_ filledColor: Color = .green) {
        self.filledColor = filledColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.title2)
            .frame(minHeight: 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(stateColor(configuration: configuration))
            )
    }
    
    func stateColor(configuration: Configuration) -> Color {
        if !enabled {
            return .gray
        }
        
        return configuration.isPressed ? filledColor.opacity(0.7) : filledColor
    }
}

public extension ButtonStyle where Self == FilledButtonStyle {

    static var filled: Self { FilledButtonStyle() }
    
    static func custom(_ filledColor: Color) -> FilledButtonStyle {
        return FilledButtonStyle(filledColor)
    }
}

public struct StrokedButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var enabled
    
    var filledColor: Color
    
    ///MARK: - Custom init with default params
    init(_ filledColor: Color = .orange) {
        self.filledColor = filledColor
    }
    
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.title2)
            .bold()
            .frame(minHeight: 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .strokeBorder(lineWidth: 1, antialiased: true)
                    .foregroundColor(stateColor(configuration: configuration))
            )
            
    }
    
    func stateColor(configuration: Configuration) -> Color {
        if !enabled {
            return .orange
        }
        return configuration.isPressed ? filledColor.opacity(0.5) : filledColor
    }
}

public extension ButtonStyle where Self == StrokedButtonStyle {

    static var stroked: Self { StrokedButtonStyle() }
    
    static func custom(_ filledColor: Color) -> StrokedButtonStyle {
        return StrokedButtonStyle(filledColor)
    }
}

#if DEBUG

struct FilledButtonStyle_Preview: PreviewProvider {
    
    static var previews: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Text("Register")
                        .fillWidth()
                }
                .buttonStyle(.filled)
                .padding(.horizontal)
                
                Button {
                    
                } label: {
                    Text("Register")
                        .fillWidth()
                }
                .buttonStyle(.filled)
                .padding(.horizontal)
                .disabled(true)
            }
            
            VStack {
                Button {
                    
                } label: {
                    Text("Register")
                        .fillWidth()
                }
                .buttonStyle(FilledButtonStyle.custom(.orange))
                .padding(.horizontal)
            }

            HStack {
                Button {
                    
                } label: {
                    Text("Hello")
                        .fillWidth()
                }
                .buttonStyle(.stroked)
                .padding(.horizontal)
                
                Button {
                    
                } label: {
                    Text("World")
                        .fillWidth()
                }
                .buttonStyle(.stroked)
                .padding(.horizontal)
                .disabled(true)
            }
            
            HStack {
                Button {
                    
                } label: {
                    Text("Hello")
                        .fillWidth()
                }
                .buttonStyle(StrokedButtonStyle(.red))
                .padding(.horizontal)
                
                Button {
                    
                } label: {
                    Text("Cinema")
                        .fillWidth()
                }
                .buttonStyle(.stroked)
                .padding(.horizontal)
                .disabled(true)
            }
        }
    }
}

#endif


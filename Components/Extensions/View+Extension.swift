//
//  View+Extension.swift
//  Cinema DB
//
//  Created by Anton.Duda on 21.12.2023.
//

import UIKit
import SwiftUI

public extension View {
    
    func minHeight(_ value: CGFloat) -> some View {
        self.frame(minHeight: value)
    }
    
    func fillWidth() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

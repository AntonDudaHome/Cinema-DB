//
//  Navigation+Extension.swift
//  Cinema DB
//
//  Created by Anton.Duda on 03.01.2024.
//

import SwiftUI
import Foundation

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

//
//  Binding+Extension.swift
//  Cinema DB
//
//  Created by Anton.Duda on 14.01.2024.
//

import SwiftUI

extension Binding {

    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value },
                       set: { value = $0 })
    }
}

//
//  TextViewInputState.swift
//  Cinema DB
//
//  Created by Anton.Duda on 17.01.2024.
//

import Foundation

@MainActor
public struct InputState {

    public var text: String
    public var error: Error?
    public var validator: InputValidator?

    public var hasError: Bool {
        return error != nil
    }

    public init(text: String = "", validator: InputValidator? = nil) {
        self.text = text
        self.validator = validator
    }

    public init(text: String = "", @ValidationBuilder validator: () -> InputValidator) {
        self.text = text
        self.validator = validator()
    }

    public mutating func validate() {
        do {
            try runValidation()
            clearError()
        } catch {
            self.error = error
        }
    }

    public mutating func clearError() {
        self.error = nil
    }

    public mutating func clearAll() {
        self.clearError()
        self.text = ""
    }

    public var isValid: Bool {
        do {
            try runValidation()
            return true
        } catch {
            return false
        }
    }

    public var errorMessage: String? {
        return error?.localizedDescription
    }

    private func runValidation() throws {
        try validator?.validate(text)
    }
}

/// Text validation protocol
public protocol InputValidator {

    func validate(_ text: String) throws
}

public extension InputValidator {

    func mapError(_ block: @escaping (_ error: Error) throws -> Void) -> ErrorMappedValidator<Self> {
        ErrorMappedValidator(value: self, mapError: block)
    }

    func mapError<T: Error>(_ error: T) -> ErrorMappedValidator<Self> {
        mapError { _ in throw error }
    }
}

public struct CombinedValidator<First: InputValidator, Second: InputValidator>: InputValidator {

    let first: First
    let second: Second

    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }

    public func validate(_ text: String) throws {
        try first.validate(text)
        try second.validate(text)
    }
}

public struct ErrorMappedValidator<T: InputValidator>: InputValidator {

    let value: T
    let mapError: (Error) throws -> Void

    public func validate(_ text: String) throws {
        do {
            try value.validate(text)
        } catch {
            try mapError(error)
        }
    }
}

@resultBuilder
public struct ValidationBuilder {

    public static func buildPartialBlock<T: InputValidator>(first: T) -> T {
        return first
    }

    public static func buildPartialBlock<C0: InputValidator, C1: InputValidator>(accumulated: C0, next: C1) -> CombinedValidator<C0, C1> {
        return CombinedValidator(first: accumulated, second: next)
    }
}

//
//  Validation.swift
//  Cinema DB
//
//  Created by Anton.Duda on 17.01.2024.
//

import Foundation

public struct NonEmpty: InputValidator {

    public enum NoEmptyValidationError: Error {
        case empty
    }

    public init() {
        
    }

    public func validate(_ text: String) throws {
        if text.isEmpty {
            throw NoEmptyValidationError.empty
        }
    }
}

extension NonEmpty.NoEmptyValidationError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .empty:
            return "Field cannot be empty"
        }
    }
}


public struct LengthValidator: InputValidator {
    
    let minLenght: Int?
    let maxLenght: Int?
    
    public init(minLenght: Int?, maxLength: Int? = nil) {
        self.minLenght = minLenght
        self.maxLenght = maxLength
    }
    
    public enum LengthValidatorError: Error {
        case tooShort, tooLong
    }
    
    public func validate(_ text: String) throws {
        if let minLenght = minLenght {
            if text.count < minLenght {
                throw LengthValidatorError.tooShort
            }
        }
        
        if let maxLenght = maxLenght {
            if text.count > maxLenght {
                throw LengthValidatorError.tooLong
            }
        }
    }
}

public struct WrongFormatValidator: InputValidator {
    
    let regex: String

    public init(regex: String) {
        self.regex = regex
    }

    public enum WrongFormatValidatorError: Error {
        case wrongFormat
    }

    public func validate(_ text: String) throws {
        let predicate = NSPredicate(format:"SELF MATCHES %@", self.regex)
        if !predicate.evaluate(with: text) {
            throw WrongFormatValidatorError.wrongFormat
        }
    }
}


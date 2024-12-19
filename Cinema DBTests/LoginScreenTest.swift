//
//  LoginScreenTest.swift
//  Cinema DBTests
//
//  Created by Anton.Duda on 11.12.2024.
//

import XCTest
import SwiftUI
import FirebaseAuth

@testable import Cinema_DB
// Unit Tests for login screen
@MainActor
final class LoginScreenTests: XCTestCase {

    var authManagerMock: AuthManagerMock!
    var loginScreen: LoginScreen!
    var routerMock: NavigationRouterMock!

    override func setUp() {
        super.setUp()
        authManagerMock = AuthManagerMock()
        routerMock = NavigationRouterMock()
        loginScreen = LoginScreen()
            .environmentObject(authManagerMock)
            .environment(\.navigationRouter, routerMock) as? LoginScreen
    }

    override func tearDown() {
        authManagerMock = nil
        routerMock = nil
        loginScreen = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testLoginButtonDisabledWhenFieldsAreEmpty() {
        // Arrange
        loginScreen.email.text = ""
        loginScreen.password.text = ""

        // Act
        let isButtonEnabled = loginScreen.isButtonEnable

        // Assert
        XCTAssertFalse(isButtonEnabled, "Login button should be disabled when fields are empty")
    }

    func testLoginButtonEnabledWhenFieldsAreValid() {
        // Arrange
        loginScreen.email.text = "test@example.com"
        loginScreen.password.text = "password123"

        // Act
        let isButtonEnabled = loginScreen.isButtonEnable

        // Assert
        XCTAssertTrue(isButtonEnabled, "Login button should be enabled when fields are valid")
    }

    func testEmailValidationFailsForInvalidEmail() {
        // Arrange
        loginScreen.email.text = "invalid-email"

        // Act
        loginScreen.email.validate()

        // Assert
        XCTAssertFalse(loginScreen.email.isValid, "Email validation should fail for invalid email")
        XCTAssertEqual(loginScreen.email.errorMessage, "Email is incorrect", "Error message should indicate incorrect email")
    }

    func testEmailValidationSucceedsForValidEmail() {
        // Arrange
        loginScreen.email.text = "test@example.com"

        // Act
        loginScreen.email.validate()

        // Assert
        XCTAssertTrue(loginScreen.email.isValid, "Email validation should succeed for valid email")
        XCTAssertNil(loginScreen.email.errorMessage, "Error message should be nil for valid email")
    }

    func testLoginActionSuccess() async {
        // Arrange
        authManagerMock.isSignInSuccessful = true
        loginScreen.email.text = "test@example.com"
        loginScreen.password.text = "password123"

        // Act
        await loginScreen.loginAction()

        // Assert
        XCTAssertTrue(authManagerMock.didCallSignIn, "signInWith should be called")
        XCTAssertTrue(routerMock.didNavigateToHomePage, "Router should navigate to HomePage on successful login")
    }

    func testLoginActionFailure() async {
        // Arrange
        authManagerMock.isSignInSuccessful = false
        loginScreen.email.text = "test@example.com"
        loginScreen.password.text = "password123"

        // Act
        await loginScreen.loginAction()

        // Assert
        XCTAssertTrue(authManagerMock.didCallSignIn, "signInWith should be called")
        XCTAssertFalse(routerMock.didNavigateToHomePage, "Router should not navigate to HomePage on failed login")
    }
}

// MARK: - Mocks

final class AuthManagerMock: AuthManager {
    var didCallSignIn = false
    var isSignInSuccessful = false

    override func signInWith(email: String, password: String) async throws -> AuthDataResult? {
        didCallSignIn = true
        if isSignInSuccessful {
            return nil
        } else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])
        }
    }
}

struct MockUser {
    let uid: String
    let email: String?
}

struct MockAuthDataResult {
    let user: MockUser
}

final class NavigationRouterMock: NavigationRouter {
    var didNavigateToHomePage = false

    override func push(destination: some View, replaceStack: Bool) {
        if destination is HomePage {
            didNavigateToHomePage = true
        }
    }
}

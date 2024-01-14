//
//  AuthService.swift
//  Cinema DB
//
//  Created by Anton.Duda on 13.01.2024.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseCore


enum AuthState {
    case authenticated
    case signedIn
    case signedOut
}

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState = AuthState.signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!

    init() {
        configureAuthStateChanges()
    }

    func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            print("Auth changed: \(user != nil)")
            Task {
                await self.updateState(user: user)
            }
        }
    }

    func removeAuthStateListener() {
        Auth.auth().removeStateDidChangeListener(authStateHandle)
    }

    func updateState(user: User?) async {
        await MainActor.run {
            self.user = user
            let isAuthenticatedUser = user != nil
            let isAnonymous = user?.isAnonymous ?? false

            if isAuthenticatedUser {
                self.authState = isAnonymous ? .authenticated : .signedIn
            } else {
                self.authState = .signedOut
            }
        }
    }
    
    func signInWith(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("FirebaseAuthSuccess: SignIn, UID:(\(String(describing: result.user.uid)))")
            return result
        }
        catch {
            print("FirebaseAuthError: failed to signIn: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signUpWith(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("FirebaseAuthSuccess: SignUp, UID:(\(String(describing: result.user.uid)))")
            return result
        }
        catch {
            print("FirebaseAuthError: failed to signUp: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() async throws {
        if let user = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
            }
            catch let error as NSError {
                print("FirebaseAuthError: failed to sign out from Firebase, \(error)")
                throw error
            }
        }
    }
}

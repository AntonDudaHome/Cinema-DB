//
//  RootView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import SwiftUI
import Firebase

enum Destinations: Hashable {
    case welcome
}

@MainActor
struct RootView: View {
    
    @State private var splash = true
    @StateObject var router: NavigationRouter
    @StateObject var authManager: AuthManager
    
    init() {
        FirebaseApp.configure()
        let router = NavigationRouter()
        let authManager = AuthManager()
        
        self._router = .init(wrappedValue: router)
        self._authManager = StateObject(wrappedValue: authManager)
    }
    
    var body: some View {
        NavigationControllerView(router) {
            SplashView()
                .bpNavigationDestination(Destinations.self) { value in
                    switch value {
                    case .welcome:
                        WelcomeView()
                    }
                }
                .onAppear {
                    Task {
                        await selectDisplayingScene()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            splash = false
                        }
                    }
                }
        }
        .environmentObject(authManager)
        .overlay(alignment: .center) {
            if splash {
                SplashView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
                    .transition(
                        .asymmetric(insertion: .opacity,
                                    removal: .scale(scale: 3).combined(with: .opacity))
                    )
            }
        }
        .animation(.default, value: splash)
    }
    
    private func selectDisplayingScene() async {
        await taskSleep(seconds: 0.5)
        
        if  authManager.authState != .signedOut {
            router.push(destination: HomePage(), replaceStack: true)
        } else {
            router.push(destination: WelcomeView())
        }
    }
}

struct LoadingKey: EnvironmentKey {
    
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    
    var isLoading: Binding<Bool> {
        get { self[LoadingKey.self] }
        set { self[LoadingKey.self] = newValue }
    }
}

func taskSleep(_ start: CFAbsoluteTime = CFAbsoluteTimeGetCurrent(), seconds: Double) async {
    let end = CFAbsoluteTimeGetCurrent()
    let delta = end - start
    let timeLeft = seconds - delta
    if timeLeft > 0 {
        do {
            if #available(iOS 16.0, *) {
                try await Task.sleep(for: .seconds(timeLeft))
            } else {
                let duration = UInt64(timeLeft * 1_000_000_000)
                try await Task.sleep(nanoseconds: duration)
            }
        } catch {
            debugPrint("Failed to wait with \(error.localizedDescription)")
        }
    }
}

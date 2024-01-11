//
//  RootView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import SwiftUI

enum Destinations: Hashable {
    
    case welcome
}

//#if DEBUG
//
//let mockServiceProvider: ServiceProvider = ServiceProvider(userManagmentBaseURL: URL(string: "https://user-management-api-dev.nela-sound.com")!,
//                                                           deviceManagmentBaseURL: URL(string: "https://subscription-management-api-dev.nela-sound.com")!,
//                                                           statisticManagmentBaseURL: URL(string: "https://audio-api-dev.nela-sound.com")!) {
//
//}
//
//#endif
//
//class LoadingStateHolder: ObservableObject {
//
//    @MainActor @Published var loading = false
//}
//
//private extension URL {
//
//    static var userManagment: URL = URL(string: "https://user-management-api-dev.nela-sound.com")!
//    static var deviceManagment: URL = URL(string: "https://subscription-management-api-dev.nela-sound.com")!
//    static var statisticManagment: URL = URL(string: "https://audio-api-dev.nela-sound.com")!
//}

@MainActor
struct RootView: View {
    
    //@State private var alertState: AlertState = .init()
    @State private var splash = true
    
    //    @StateObject private var loading: LoadingStateHolder = .init()
    //    @StateObject private var provider: ServiceProvider
    @StateObject var router: NavigationRouter
    //    @StateObject var networkMonitor = NetworkMonitor()
    //    private var dataManager: DataManager {
    //        provider.dataManager
    //    }
    
    init() {
        let router = NavigationRouter()
        //        let provider = ServiceProvider(userManagmentBaseURL: .userManagment,
        //                                       deviceManagmentBaseURL: .deviceManagment,
        //                                       statisticManagmentBaseURL: .statisticManagment) { [weak router] in
        //            router?.popTo(destintion: WelcomeScreen())
        //        }
        //        self._provider = .init(wrappedValue: provider)
        self._router = .init(wrappedValue: router)
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
        router.push(destination: WelcomeView())
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

//
//  Cinema_DBApp.swift
//  Cinema DB
//
//  Created by Anton.Duda on 20.12.2023.
//

import SwiftUI
import FirebaseCore

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

    func application(_: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sessionRole = connectingSceneSession.role
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupApperence()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: rootView)
        window?.makeKeyAndVisible()
    }

    private func setupApperence() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundColor = .white

        navigationBarAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "8bitOperatorPlus-Bold", size: 28)!,
            .foregroundColor: UIColor(.cinemaBlack)
        ]
        navigationBarAppearance.titleTextAttributes = [
            .font: UIFont(name: "8bitOperatorPlus-Bold", size: 18)!,
            .foregroundColor: UIColor(.cinemaBlack)
        ]

        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance

        UIScrollView.appearance().keyboardDismissMode = .onDragWithAccessory

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.systemGray6

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    @ViewBuilder
    private var rootView: some View {
        RootView()
            .ignoresSafeArea(.all)
            .preferredColorScheme(.light)
            .withKeyboardDissmiss(.onDragWithAccessory)
    }
}

extension View {

    @ViewBuilder
    func withKeyboardDissmiss(_ mode: UIScrollView.KeyboardDismissMode) -> some View {
        if #available(iOS 16.0, *) {
            switch mode {
            case .none:
                self
                    .scrollDismissesKeyboard(.automatic)
            case .onDrag, .onDragWithAccessory:
                self
                    .scrollDismissesKeyboard(.immediately)
            case .interactive, .interactiveWithAccessory:
                self
                    .scrollDismissesKeyboard(.interactively)
            @unknown default:
                self
            }
        } else {
            self
        }
    }
}

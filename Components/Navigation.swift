//
//  Navigation.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import Foundation
import SwiftUI
import UIKit
import Logger
import Combine

protocol NavigationDestination {

    associatedtype I: Hashable
    associatedtype V: View

    var dataType: I.Type { get }
    var viewType: V.Type { get }

    func apply(_ value: I) -> V
}

struct NavigationDestinationBox<I: Hashable, V: View>: NavigationDestination {

    var dataType: I.Type
    var viewType: V.Type
    let block: (I) -> V

    init(_ block: @escaping (I) -> V) {
        self.block = block
        self.viewType = V.self
        self.dataType = I.self
    }

    func apply(_ value: I) -> V {
        return block(value)
    }
}

extension UINavigationController {

    func controller(with id: ObjectIdentifier) -> UIViewController? {
        return viewControllers.first(where: { ObjectIdentifier(type(of: $0)) == id })
    }
}

final class NavigationRouter: ObservableObject {

    var navigationvc: UINavigationController?
    private var destinations: [ObjectIdentifier: any NavigationDestination] = [:]

    public init() {

    }

    @MainActor
    public func push(destination: some View, replaceStack: Bool = false) {
        navigate(to: createViewController(with: destination), replaceStack: replaceStack)
    }

    @MainActor
    public func push(_ value: some Hashable, replaceStack: Bool = false) {
        let id = ObjectIdentifier(type(of: value))
        guard let navigationDestination = destinations[id] else {
            Log(error: "Failed to get destination to %@", String(describing: value))
#if DEBUG
            fatalError("Navigation should be registered at this moment")
#else
            return
#endif
        }
        let casted = unwrapView(viewType: navigationDestination.viewType,
                          data: value,
                          navigationDestination: navigationDestination)
        navigate(to: casted, replaceStack: replaceStack)
    }

    private func navigate(to vc: UIViewController, replaceStack: Bool) {
        if let top = navigationvc?.topViewController {
            Log("PUSH from %@", "\(type(of: top))")
            if ObjectIdentifier(type(of: vc)) == ObjectIdentifier(type(of: top)) {
                return
            }
        }
        Log("PUSH to %@", "\(type(of: vc))")
        if replaceStack {
            navigationvc?.setViewControllers([vc], animated: true)
        } else {
            navigationvc?.pushViewController(vc, animated: true)
        }
    }

    @MainActor
    func navigate(to view: any View, replaceStack: Bool) {
        @MainActor
        func performNavigation<T: View>(opened: T) {
            let vc = createViewController(with: opened)
            Log("Make type vc %@ %@", "\(type(of: vc))", "\(ObjectIdentifier(type(of: vc)))")
            navigate(to: vc, replaceStack: replaceStack)
        }
        performNavigation(opened: view)
    }

    @MainActor
    func onPopToRoot(_ action: () -> Bool) {
        if action() {
            popToRoot()
        }
    }

    @MainActor
    func pop() {
        navigationvc?.popViewController(animated: true)
    }

    @MainActor
    func popToRoot() {
        navigationvc?.popToRootViewController(animated: true)
    }

    @MainActor
    func popTo(destintion: some View) {
        guard let navigationvc, let lastInStack = navigationvc.topViewController else { return }
        let destintion = createViewController(with: destintion)
        popTo(destintion: destintion, lastInStack: lastInStack)
    }

    @MainActor
    func popTo<D: Hashable>(destintion: D) {
        guard let navigationvc, let lastInStack = navigationvc.topViewController else { return }
        let id = ObjectIdentifier(type(of: destintion))
        guard let gbtbox = destinations[id] else {
            Log(error: "Failed to get destination to %@", String(describing: destintion))
            #if DEBUG
            fatalError("Navigation should be registered at this moment")
            #else
            return
            #endif
        }
        let casted = unwrapView(viewType: gbtbox.viewType, data: destintion, navigationDestination: gbtbox)
        popToView(view: casted, lastInStack: lastInStack)
    }

    func navigationDestination<D>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> some View) where D: Hashable {
        let id = ObjectIdentifier(data)
        destinations[id] = NavigationDestinationBox { v in
            destination(v)
        }
    }

    @MainActor func popToView(view: any View, lastInStack: UIViewController) {
        @MainActor func popToCastedView<T: View>(opened: T) {
            let vc = createViewController(with: opened)
            Log("Make type vc %@ %@", "\(type(of: vc))", "\(ObjectIdentifier(type(of: vc)))")
            popTo(destintion: vc, lastInStack: lastInStack)
        }
        popToCastedView(opened: view)
    }

    func unwrapView<D: Hashable, V: View>(viewType: V.Type, data: D, navigationDestination: any NavigationDestination) -> V {
        func asNavigationBox<T: NavigationDestination>(_ v: T) -> NavigationDestinationBox<D, V> {
            // swiftlint:disable force_cast
            return v as! NavigationDestinationBox<D, V>
            // swiftlint:enable force_cast
        }
        return asNavigationBox(navigationDestination).block(data)
    }

    private func popTo(destintion: UIViewController, lastInStack: UIViewController) {
        if let top = navigationvc?.topViewController {
            if ObjectIdentifier(type(of: destintion)) == ObjectIdentifier(type(of: top)) {
                return
            }
        }

        let destintion = {
            if let inStack = navigationvc?.controller(with: ObjectIdentifier(type(of: destintion))) {
                return inStack
            }
            return destintion
        }()

        Log("POP from %@ %@", "\(type(of: lastInStack))", "\(ObjectIdentifier(type(of: lastInStack)))")
        Log("POP to %@ %@", "\(type(of: destintion))", "\(ObjectIdentifier(type(of: destintion)))")

        if let presented = navigationvc?.presentedViewController {
            presented.dismiss(animated: true) { [unowned self] in
                navigationvc?.setViewControllers([destintion, lastInStack], animated: false)
                navigationvc?.popToViewController(destintion, animated: true)
            }
        } else {
            navigationvc?.setViewControllers([destintion, lastInStack], animated: false)
            navigationvc?.popToViewController(destintion, animated: true)
        }
    }

    @MainActor
    private func createViewController<V: View>(with view: V) -> BPHostingViewController<V> {
        let viewController = BPHostingViewController(
            rootView: view
        )
        return viewController
    }
}

struct NavigationRouterKey: EnvironmentKey {
    public static var defaultValue: NavigationRouter?
}

extension EnvironmentValues {
    var navigationRouter: NavigationRouter {
        get {
            self[NavigationRouterKey.self] ?? NavigationRouter()
        }
        set {
            self[NavigationRouterKey.self] = newValue
        }
    }
}

struct NavigationControllerView<Root: View>: View {
    let root: () -> Root

    @StateObject var router: NavigationRouter

    init(_ router: NavigationRouter = NavigationRouter(), root: @escaping () -> Root) {
        self.root = root
        self._router = .init(wrappedValue: router)
    }

    var body: some View {
        NavigationReprezentation {
            root()
        }
        .environment(\.navigationRouter, router)
        //.modifier(ScreenCoverPresentation())
    }
}

struct NavigationReprezentation<Root: View>: UIViewControllerRepresentable {
    public let root: () -> Root
    @Environment(\.navigationRouter) var router

    init(root: @escaping () -> Root) {
        self.root = root
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let view = root()
        let nvc = UINavigationController(rootViewController: BPHostingViewController(rootView: view))
        nvc.navigationBar.prefersLargeTitles = true
        nvc.delegate = context.coordinator
        router.navigationvc = nvc
        return nvc
    }

    func updateUIViewController(_: UINavigationController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UINavigationControllerDelegate {
        func navigationController(_ navigationController: UINavigationController, willShow vc: UIViewController, animated _: Bool) {
            vc.navigationItem.backButtonTitle = " "
        }

        func navigationController(_: UINavigationController, didShow vc: UIViewController, animated _: Bool) {
        }
    }
}

struct DestintionRegistration<D: Hashable, V: View>: ViewModifier {
    let destination: (D) -> V
    @Environment(\.navigationRouter) var router

    func body(content: Content) -> some View {
        content
            .onAppear {
                router.navigationDestination(for: D.self, destination: destination)
            }
    }
}

extension View {
    func bpNavigationDestination<D: Hashable>(_: D.Type, @ViewBuilder destination: @escaping (D) -> some View) -> some View {
        self.modifier(DestintionRegistration(destination: destination))
    }
}

@MainActor
struct BPNavigationLink<Label: View, Destination: View>: View {
    let label: () -> Label
    let replaceStack: Bool
    let action: (NavigationRouter) -> Void
    @Environment(\.navigationRouter) var router

    init(replaceStack: Bool = false, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.replaceStack = replaceStack
        action = { router in
            let d = destination()
            router.push(destination: d, replaceStack: replaceStack)
        }
    }

    init(replaceStack: Bool = false, model: some Hashable, @ViewBuilder label: @escaping () -> Label) {
        self.replaceStack = replaceStack
        self.label = label
        action = { router in
            router.push(model)
        }
    }

    var body: some View {
        Button {
            action(router)
        } label: {
            label()
        }
    }
}

struct ShowHideBarPreff: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    func bpNavigationBarHidden(_ value: Bool) -> some View {
        preference(key: ShowHideBarPreff.self, value: value)
    }
}

struct ScreenTitle: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public let value: String

    public init(stringLiteral: String) {
        self.value = stringLiteral
    }
}

func findTitle<T, I>(in object: I) -> T? {
    if object is ObservableObjectPublisher {
        return nil
    }
    let mirror = Mirror(reflecting: object)
    for child in mirror.children {
        if let value = child.value as? T {
            return value
        }
        if let value: T = findTitle(in: child.value) {
            return value
        }
    }
    return nil
}

struct HostRootView<T: View>: View {

    @Binding var hideBar: Bool?
    let content: () -> T

    var body: some View {
        content()
            .onPreferenceChange(ShowHideBarPreff.self, perform: { value in
                hideBar = value
            })
    }
}

class BPHostingViewController<T: View>: UIHostingController<HostRootView<T>> {

    private var hideBar: Bool? {
        someBool.value
    }

    class SomeBool {

        var value: Bool? {
            didSet {
                onChange?(value)
            }
        }
        var onChange: ((Bool?) -> Void)?

        init(value: Bool? = nil) {
            self.value = value
        }
    }

    let someBool: SomeBool

    init(rootView: T) {

        let someBool = SomeBool()

        let host = HostRootView(hideBar: .init(get: { [unowned someBool] in
            someBool.value
        }, set: { [unowned someBool] value in
            someBool.value = value
        })) {
            rootView
        }

        self.someBool = someBool

        super.init(
            rootView: host
        )

        someBool.onChange = { [weak self] value in
            guard let value else { return }
            self?.onHideBarChanged(value)
        }

        let title: String? = {
            if let stateTitle: State<ScreenTitle> = findTitle(in: rootView) {
                return stateTitle.wrappedValue.value
            }
            if let title: ScreenTitle = findTitle(in: rootView) {
                return title.value
            }
            return nil
        }()
        self.title = title
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func onHideBarChanged(_ value: Bool) {
        guard let nvc = navigationController else { return }
        if !nvc.isNavigationBarHidden && value {
            nvc.setNavigationBarHidden(value, animated: true)
        } else if nvc.isNavigationBarHidden && !value {
            nvc.setNavigationBarHidden(value, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let bar = hideBar {
            navigationController?.setNavigationBarHidden(bar, animated: animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

struct StoreKey<T> {

    let value: T
}

struct EnvPK<T>: EnvironmentKey {

    static var defaultValue: StoreKey<T>? {
        nil
    }
}

extension EnvironmentValues {

    mutating func doSome<T>(inp: T) {
        self[EnvPK<StoreKey<T>>.self] = .init(value: .init(value: inp))
    }
}

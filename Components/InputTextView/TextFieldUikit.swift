//
//  TextFieldUikit.swift
//  Cinema DB
//
//  Created by Anton.Duda on 17.01.2024.
//

import SwiftUI

// MARK: - UITextField Representable

final class CustomTextField: UITextField {

    var returnEnabled: Bool = true {
        didSet {
            if oldValue == returnEnabled {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.reloadInputViews()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var hasText: Bool {
        if let text {
            return !text.isEmpty && returnEnabled
        }
        return false
    }
}

public struct PlaceholderAttributes {
    public let color: UIColor
    public let font: UIFont

    public init(color: UIColor, font: UIFont) {
        self.color = color
        self.font = font
    }
}

protocol UpdateIfOther {
}

extension UpdateIfOther where Self: UIView {

    func update<T>(_ kp: ReferenceWritableKeyPath<Self, T>, _ value: T) {
        self[keyPath: kp] = value
    }

    func update<T>(_ kp: ReferenceWritableKeyPath<Self, T>, _ value: T) where T: Equatable {
        if self[keyPath: kp] != value {
            self[keyPath: kp] = value
        }
    }
}

extension UIView: UpdateIfOther {

}

struct UIKitTextField: UIViewRepresentable {

    let placeholder: String
    var isSecure: Bool = false
    @Binding var text: String

    @Environment(\.isEnabled) private var enabled

    @Environment(\.uiKeyboardType) private var uiKeyboardType
    @Environment(\.uiReturnKeyType) private var uiReturnKeyType
    @Environment(\.uiTextAutocapitalizationType) private var uiTextAutocapitalizationType
    @Environment(\.uiTextAutocorrectionType) private var uiTextAutocorrectionType
    @Environment(\.uiTextSpellCheckingType) private var uiTextSpellCheckingType
    @Environment(\.iuTextContentType) private var iuTextContentType
    @Environment(\.uiTextColor) private var uiTextColor
    @Environment(\.uiTextFont) private var uiTextFont
    @Environment(\.uiSubmitAction) private var uiSubmitAction
    @Environment(\.uiOnEndEditing) private var uiOnEndEditing
    @Environment(\.uiOnBeginEditing) private var uiOnBeginEditing
    @Environment(\.uiReturnKeyEnabled) private var returnKeyEnabled
    @Environment(\.uiPlaceholderAttributes) private var placeholderAttributes

    func makeUIView(context: Context) -> CustomTextField {
        let text = CustomTextField(frame: .zero)
        text.delegate = context.coordinator
        text.addTarget(context.coordinator, action: #selector(Coordinator.onTextChanged(_:)), for: .editingChanged)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.setContentHuggingPriority(.required, for: .vertical)
        updateView(text)
        return text
    }

    func updateUIView(_ uiView: CustomTextField, context: Context) {

        updateView(uiView)

        context.coordinator.submitAction = uiSubmitAction
        context.coordinator.onEndEditing = uiOnEndEditing
        context.coordinator.onBeginEditing = uiOnBeginEditing
    }

    private func updateView(_ uiView: CustomTextField) {

        uiView.update(\.returnEnabled, returnKeyEnabled)

        if !returnKeyEnabled {
            uiView.update(\.enablesReturnKeyAutomatically, true)
        }

        uiView.update(\.text, text)
        uiView.update(\.isSecureTextEntry, isSecure)

        if let placeholderAttributes {
            let attributes = [
                NSAttributedString.Key.foregroundColor: placeholderAttributes.color,
                NSAttributedString.Key.font: placeholderAttributes.font // Note the !
            ]
            uiView.update(\.attributedPlaceholder, NSAttributedString(string: placeholder,
                                                                      attributes: attributes))
        } else {
            uiView.update(\.attributedPlaceholder, nil)
            uiView.update(\.placeholder, placeholder)
        }

        uiView.update(\.isEnabled, enabled)
        uiView.update(\.keyboardType, uiKeyboardType)
        uiView.update(\.returnKeyType, uiReturnKeyType)
        uiView.update(\.autocapitalizationType, uiTextAutocapitalizationType)
        uiView.update(\.autocorrectionType, uiTextAutocorrectionType)
        uiView.update(\.spellCheckingType, uiTextSpellCheckingType)
        uiView.update(\.textContentType, iuTextContentType)
        uiView.update(\.textColor, uiTextColor)
        uiView.update(\.font, uiTextFont)
    }

    static func dismantleUIView(_ uiView: UITextField, coordinator: Coordinator) {
        uiView.resignFirstResponder()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        internal init(text: Binding<String>) {
            self._text = text
        }

        var submitAction: (() -> Void)?
        var onEndEditing: (() -> Void)?
        var onBeginEditing: (() -> Void)?

        @Binding var text: String

        @objc fileprivate func onTextChanged(_ sender: UITextField) {
            text = sender.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            submitAction?()
            return true
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            onBeginEditing?()
        }

        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            onEndEditing?()
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return true
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            return true
        }
    }
}

// MARK: - UITextField EnvironmentKeys

struct UITextFieldKeyboardTypeKey: EnvironmentKey {
    static var defaultValue: UIKeyboardType = .default
}

struct UITextFieldReturnKeyTypeKey: EnvironmentKey {
    static var defaultValue: UIReturnKeyType = .default
}

struct UITextFieldTextAutocapitalizationTypeKey: EnvironmentKey {
    static var defaultValue: UITextAutocapitalizationType = .sentences
}

struct UITextFieldTextAutocorrectionTypeKey: EnvironmentKey {
    static var defaultValue: UITextAutocorrectionType = .default
}

struct UITextFieldTextSpellCheckingTypeKey: EnvironmentKey {
    static var defaultValue: UITextSpellCheckingType = .default
}

struct UITextFieldTextContentTypeKey: EnvironmentKey {
    static var defaultValue: UITextContentType?
}

struct UITextFieldTextColorKey: EnvironmentKey {
    static var defaultValue: UIColor?
}

struct UITextFieldFontKey: EnvironmentKey {
    static var defaultValue: UIFont?
}

struct UITextFieldSubmitActionKey: EnvironmentKey {
    static var defaultValue: (() -> Void)?
}

struct UITextFieldDidEndEditingActionKey: EnvironmentKey {
    static var defaultValue: (() -> Void)?
}

struct UITextFieldDidBeginEditingActionKey: EnvironmentKey {
    static var defaultValue: (() -> Void)?
}

struct UITextFieldReturnKeyEnabled: EnvironmentKey {
    static var defaultValue: Bool = true
}

struct UITextFieldPlaceholderAttributesKey: EnvironmentKey {
    static var defaultValue: PlaceholderAttributes?
}

public extension EnvironmentValues {

    var uiKeyboardType: UIKeyboardType {
        get { self[UITextFieldKeyboardTypeKey.self] }
        set { self[UITextFieldKeyboardTypeKey.self] = newValue }
    }

    var uiReturnKeyType: UIReturnKeyType {
        get { self[UITextFieldReturnKeyTypeKey.self] }
        set { self[UITextFieldReturnKeyTypeKey.self] = newValue }
    }

    var uiTextAutocapitalizationType: UITextAutocapitalizationType {
        get { self[UITextFieldTextAutocapitalizationTypeKey.self] }
        set { self[UITextFieldTextAutocapitalizationTypeKey.self] = newValue }
    }

    var uiTextAutocorrectionType: UITextAutocorrectionType {
        get { self[UITextFieldTextAutocorrectionTypeKey.self] }
        set { self[UITextFieldTextAutocorrectionTypeKey.self] = newValue }
    }

    var uiTextSpellCheckingType: UITextSpellCheckingType {
        get { self[UITextFieldTextSpellCheckingTypeKey.self] }
        set { self[UITextFieldTextSpellCheckingTypeKey.self] = newValue }
    }

    var iuTextContentType: UITextContentType? {
        get { self[UITextFieldTextContentTypeKey.self] }
        set { self[UITextFieldTextContentTypeKey.self] = newValue }
    }

    var uiTextColor: UIColor? {
        get { self[UITextFieldTextColorKey.self] }
        set { self[UITextFieldTextColorKey.self] = newValue }
    }

    var uiTextFont: UIFont? {
        get { self[UITextFieldFontKey.self] }
        set { self[UITextFieldFontKey.self] = newValue }
    }

    var uiSubmitAction: (() -> Void)? {
        get { self[UITextFieldSubmitActionKey.self] }
        set { self[UITextFieldSubmitActionKey.self] = newValue }
    }

    var uiOnEndEditing: (() -> Void)? {
        get { self[UITextFieldDidEndEditingActionKey.self] }
        set { self[UITextFieldDidEndEditingActionKey.self] = newValue }
    }

    var uiOnBeginEditing: (() -> Void)? {
        get { self[UITextFieldDidBeginEditingActionKey.self] }
        set { self[UITextFieldDidBeginEditingActionKey.self] = newValue }
    }

    var uiReturnKeyEnabled: Bool {
        get { self[UITextFieldReturnKeyEnabled.self] }
        set { self[UITextFieldReturnKeyEnabled.self] = newValue }
    }

    var uiPlaceholderAttributes: PlaceholderAttributes? {
        get { self[UITextFieldPlaceholderAttributesKey.self] }
        set { self[UITextFieldPlaceholderAttributesKey.self] = newValue }
    }
}

public extension View {

    func uiKeyboardType(_ value: UIKeyboardType) -> some View {
        self.environment(\.uiKeyboardType, value)
    }

    func uiReturnKeyType(_ value: UIReturnKeyType) -> some View {
        self.environment(\.uiReturnKeyType, value)
    }

    func uiTextAutocapitalizationType(_ value: UITextAutocapitalizationType) -> some View {
        self.environment(\.uiTextAutocapitalizationType, value)
    }

    func uiTextAutocorrectionType(_ value: UITextAutocorrectionType) -> some View {
        self.environment(\.uiTextAutocorrectionType, value)
    }

    func uiTextSpellCheckingType(_ value: UITextSpellCheckingType) -> some View {
        self.environment(\.uiTextSpellCheckingType, value)
    }

    func uiTextContentType(_ value: UITextContentType?) -> some View {
        self.environment(\.iuTextContentType, value)
    }

    func uiTextColor(_ value: UIColor?) -> some View {
        self.environment(\.uiTextColor, value)
    }

    func uiTextFont(_ value: UIFont?) -> some View {
        self.environment(\.uiTextFont, value)
    }

    func uiSubmitAction(_ value: (() -> Void)?) -> some View {
        self.environment(\.uiSubmitAction, value)
    }

    func uiOnEndEditing(_ value: (() -> Void)?) -> some View {
        self.environment(\.uiOnEndEditing, value)
    }

    func uiOnBeginEditing(_ value: (() -> Void)?) -> some View {
        self.environment(\.uiOnBeginEditing, value)
    }

    func uiReturnKeyEnabled(_ value: Bool) -> some View {
        self.environment(\.uiReturnKeyEnabled, value)
    }

    func uiTextPlaceholderAttributes(_ value: PlaceholderAttributes) -> some View {
        self.environment(\.uiPlaceholderAttributes, value)
    }
}

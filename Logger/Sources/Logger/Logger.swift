import SwiftUI
import os.log

public struct Debugger {

    private var log: OSLog
    let signpostID: OSSignpostID

    public init(subsystem: String, category: String) {
        let osLog = OSLog(subsystem: subsystem, category: category)
        log = osLog
        signpostID = OSSignpostID(log: osLog)
    }

    public init(_ log: OSLog) {
        self.log = log
        signpostID = OSSignpostID(log: log)
    }

    public init() {
        self.log = OSLog.default
        signpostID = OSSignpostID(log: OSLog.default)
    }

    public func callAsFunction(_ message: StaticString, file: String = #file, function: String = #function, line: Int = #line, _ args: CVarArg...) {
        log(level: .default, message: message, args: args, file: file, function: function, line: line)
    }

    public func callAsFunction(info message: StaticString, file: String = #file, function: String = #function, line: Int = #line, _ args: CVarArg...) {
        log(level: .info, message: message, args: args, file: file, function: function, line: line)
    }

    public func callAsFunction(debug message: StaticString, file: String = #file, function: String = #function, line: Int = #line, _ args: CVarArg...) {
        log(level: .debug, message: message, args: args, file: file, function: function, line: line)
    }

    public func callAsFunction(error message: StaticString, file: String = #file, function: String = #function, line: Int = #line, _ args: CVarArg...) {
        log(level: .error, message: message, args: args, file: file, function: function, line: line)
    }

    public func callAsFunction(fault message: StaticString, file: String = #file, function: String = #function, line: Int = #line, _ args: CVarArg...) {
        log(level: .fault, message: message, args: args, file: file, function: function, line: line)
    }

    /// Log error in console when error in present
    /// - Parameter error: error to log
    public func callAsFunction(error: Error?, file: String = #file, function: String = #function, line: Int = #line) {
        if let error {
            self.callAsFunction(error: "Error %@", file: file, function: function, String(describing: error))
        }
    }

    private func log(level: OSLogType,
                     message: StaticString,
                     args: CVarArg...,
                     file: String,
                     function: String,
                     line: Int) {
        let last = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        if !args.isEmpty {
            let form = String(format: "\(message)", args)
#if DEBUG
            os_log(level, log: log, "%@.%@[%@]: %@", last, function, String(line), "\(form)")
#else
            os_log(level, log: log, "%@: %{public}@", function, "\(form)")
#endif
        } else {
#if DEBUG
            os_log(level, log: log, "%@.%@[%@]: %@", last, function, String(line), "\(message)")
#else
            os_log(level, log: log, "%@: %@", function, "\(message)")
#endif
        }
    }
}

public let Log: Debugger = DebuggerEnvKey.defaultValue

struct DebuggerEnvKey: EnvironmentKey {

    static var defaultValue: Debugger = .init(subsystem: "com.nela.care.debuger", category: "default")
}

public extension EnvironmentValues {

    var debugger: Debugger {
        get { self[DebuggerEnvKey.self] }
        set { self[DebuggerEnvKey.self] = newValue }
    }
}

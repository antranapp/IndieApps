//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

/// A type safe property wrapper to set and get values from UserDefaults with support for defaults values.
///
/// Usage:
/// ```
/// @UserDefault("has_seen_app_introduction", defaultValue: false)
/// static var hasSeenAppIntroduction: Bool
/// ```
///
/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@propertyWrapper
struct UserDefault<Value: PropertyListValue> {

    let key: Key
    let defaultValue: Value
    var userDefaults: UserDefaults

    public init(_ key: Key, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    var projectedValue: UserDefault<Value> { return self }

    func observe(change: @escaping (Value?, Value?) -> Void) -> NSObject {
        return UserDefaultsObservation(key: key) { old, new in
            change(old as? Value, new as? Value)
        }
    }

}

/// A type than can be stored in `UserDefaults`.
///
/// - From UserDefaults;
/// The value parameter can be only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary.
/// For NSArray and NSDictionary objects, their contents must be property list objects. For more information, see What is a
/// Property List? in Property List Programming Guide.
public protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension NSData: PropertyListValue {}

extension String: PropertyListValue {}
extension NSString: PropertyListValue {}

extension Date: PropertyListValue {}
extension NSDate: PropertyListValue {}

extension NSNumber: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Int8: PropertyListValue {}
extension Int16: PropertyListValue {}
extension Int32: PropertyListValue {}
extension Int64: PropertyListValue {}
extension UInt: PropertyListValue {}
extension UInt8: PropertyListValue {}
extension UInt16: PropertyListValue {}
extension UInt32: PropertyListValue {}
extension UInt64: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}
#if os(macOS)
extension Float80: PropertyListValue {}
#endif

extension Array: PropertyListValue where Element: PropertyListValue {}

extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

class UserDefaultsObservation: NSObject {
    let key: Key
    private var onChange: (Any, Any) -> Void

    init(key: Key, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: nil)
    }

    // swiftlint:disable:next block_based_kvo
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }
}

struct Key: RawRepresentable {
    let rawValue: String
}

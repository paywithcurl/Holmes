import Foundation
import CoreGraphics

public protocol Deserialize {
    static func from(json: AnyObject) throws -> Self
}

extension UUID: Deserialize {
    public static func from(json: AnyObject) throws -> UUID {
        guard let s = json as? String, let uuid = UUID(uuidString: s) else {
            throw DeserializeError.custom(message: "malformed UUID: \(json)")
        }

        return uuid
    }
}

extension Date: Deserialize {
    public static func from(json: AnyObject) throws -> Date {
        guard let s = json as? String, let date = DateFormatter.rfc3339.date(from: s) else {
            throw DeserializeError.custom(message: "malformed date: \(json)")
        }

        return date
    }
}

public func deserialize<T>(from dict: AnyObject, key: String) throws -> T {
    throw DeserializeError.notDeserializable
}

public func deserialize<T: Deserialize>(from dict: AnyObject, key: String) throws -> T {
    guard let dict = dict as? [AnyHashable: AnyObject] else {
        throw DeserializeError.structNotDictionaryRepr
    }

    return try T.from(json: dict[key] as AnyObject)
}

public func deserialize<T: Deserialize>(from dict: AnyObject, key: String) throws -> T? {
    guard let dict = dict as? [AnyHashable: AnyObject] else {
        throw DeserializeError.structNotDictionaryRepr
    }

    guard let value = dict[key] else {
        return nil
    }

    return try T.from(json: value)
}

extension NSNull: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard json is NSNull else {
            throw DeserializeError.typeMismatch
        }
        return self.init()
    }
}

extension NSNumber: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return self.init(value: value.int64Value)
    }
}

/*
extension Bool: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.boolValue
    }
}

extension Int: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.intValue
    }
}

extension Int8: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.int8Value
    }
}

extension Int16: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.int16Value
    }
}

extension Int32: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.int32Value
    }
}

extension Int64: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.int64Value
    }
}

extension UInt: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.uintValue
    }
}

extension UInt8: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.uint8Value
    }
}

extension UInt16: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.uint16Value
    }
}

extension UInt32: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.uint32Value
    }
}

extension UInt64: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.uint64Value
    }
}
*/

extension Float: Deserialize {
    public static func from(json: AnyObject) throws -> Float {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.floatValue
    }
}

/*
extension Double: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self = value.doubleValue
    }
}

extension CGFloat: Deserialize {
    public init(json: AnyObject) throws {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        self.init(value.doubleValue)
    }
}

extension NSString: Deserialize {
    public convenience init(json: AnyObject) throws {
        guard let value = json as? NSString else {
            throw DeserializeError.typeMismatch
        }
        self = value
    }
}
*/

extension String: Deserialize {
    public static func from(json: AnyObject) throws -> String {
        guard let value = json as? NSString else {
            throw DeserializeError.typeMismatch
        }
        return value as String
    }
}

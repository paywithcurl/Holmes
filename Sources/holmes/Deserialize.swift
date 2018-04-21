import Foundation
import CoreGraphics

public protocol Deserialize {
    static func from(json: AnyObject) throws -> Self
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

    if value is NSNull {
        return nil
    }

    return try T.from(json: value)
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

extension Bool: Deserialize {
    public static func from(json: AnyObject) throws -> Bool {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.boolValue
    }
}

extension Int: Deserialize {
    public static func from(json: AnyObject) throws -> Int {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.intValue
    }
}

extension Int8: Deserialize {
    public static func from(json: AnyObject) throws -> Int8 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.int8Value
    }
}

extension Int16: Deserialize {
    public static func from(json: AnyObject) throws -> Int16 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.int16Value
    }
}

extension Int32: Deserialize {
    public static func from(json: AnyObject) throws -> Int32 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.int32Value
    }
}

extension Int64: Deserialize {
    public static func from(json: AnyObject) throws -> Int64 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.int64Value
    }
}

extension UInt: Deserialize {
    public static func from(json: AnyObject) throws -> UInt {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.uintValue
    }
}

extension UInt8: Deserialize {
    public static func from(json: AnyObject) throws -> UInt8 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.uint8Value
    }
}

extension UInt16: Deserialize {
    public static func from(json: AnyObject) throws -> UInt16 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.uint16Value
    }
}

extension UInt32: Deserialize {
    public static func from(json: AnyObject) throws -> UInt32 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.uint32Value
    }
}

extension UInt64: Deserialize {
    public static func from(json: AnyObject) throws -> UInt64 {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.uint64Value
    }
}

extension Float: Deserialize {
    public static func from(json: AnyObject) throws -> Float {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.floatValue
    }
}

extension Double: Deserialize {
    public static func from(json: AnyObject) throws -> Double {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return value.doubleValue
    }
}

extension CGFloat: Deserialize {
    public static func from(json: AnyObject) throws -> CGFloat {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }
        return CGFloat(value.doubleValue)
    }
}

extension NSString: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? NSString else {
            throw DeserializeError.typeMismatch
        }
        return self.init(string: value as String)
    }
}

extension String: Deserialize {
    public static func from(json: AnyObject) throws -> String {
        guard let value = json as? NSString else {
            throw DeserializeError.typeMismatch
        }
        return value as String
    }
}

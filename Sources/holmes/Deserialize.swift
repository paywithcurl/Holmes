import Foundation
import CoreGraphics

public protocol Deserialize {
    static func from(json: AnyObject) throws -> Self
}

public func deserialize<T>(_ json: AnyObject) throws -> T {
    if let ty = T.self as? Deserialize.Type {
        return try ty.from(json: json) as! T // did I mention Swift's type system is stupid?
    } else {
        throw DeserializeError.notDeserializable
    }
}

public func deserialize<T: Deserialize>(from dict: AnyObject, key: String) throws -> T {
    guard let dict = dict as? [AnyHashable: AnyObject] else {
        throw DeserializeError.structNotDictionaryRepr
    }

    return try T.from(json: dict[key] as AnyObject)
}

extension NSNull: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard json is NSNull else {
            throw DeserializeError.typeMismatch
        }
        return self.init()
    }
}

extension Optional: Deserialize {
    public static func from(json: AnyObject) throws -> Optional {
        if json is NSNull {
            return nil
        }

        return try deserialize(json) as Wrapped
    }
}

extension NSNumber: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? NSNumber else {
            throw DeserializeError.typeMismatch
        }

        if
          value.objCType[0] == Character("f").unicodeScalars.first!.value
          ||
          value.objCType[0] == Character("d").unicodeScalars.first!.value
        {
            return self.init(value: value.doubleValue)
        } else {
            return self.init(value: value.int64Value)
        }
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

extension UUID: Deserialize {
    public static func from(json: AnyObject) throws -> UUID {
        guard let s = json as? NSString,
              let uuid = UUID(uuidString: s as String)
        else {
            throw DeserializeError.custom(message: "malformed UUID: \(json)")
        }

        return uuid
    }
}

extension Date: Deserialize {
    public static func from(json: AnyObject) throws -> Date {
        guard let s = json as? NSString,
              let date = DateFormatter.rfc3339.date(from: s as String)
        else {
            throw DeserializeError.custom(message: "malformed date: \(json)")
        }

        return date
    }
}

extension NSArray: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? NSArray else {
            throw DeserializeError.typeMismatch
        }

        return self.init(array: value as [AnyObject])
    }
}

extension Array: Deserialize {
    public static func from(json: AnyObject) throws -> Array {
        guard let value = json as? NSArray else {
            throw DeserializeError.typeMismatch
        }

        return try value.map { try deserialize($0 as AnyObject) }
    }
}

extension NSDictionary: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? [AnyHashable: AnyObject] else {
            throw DeserializeError.typeMismatch
        }

        return self.init(dictionary: value)
    }
}

extension Dictionary: Deserialize {
    public static func from(json: AnyObject) throws -> Dictionary {
        guard let dict = json as? [AnyHashable: AnyObject] else {
            throw DeserializeError.typeMismatch
        }

        var result: [Key: Value] = [:]

        for (key, value) in dict {
            let newKey: Key   = try deserialize(key   as AnyObject)
            let newVal: Value = try deserialize(value as AnyObject)

            result[newKey] = newVal
        }

        return result
    }
}

extension NSSet: Deserialize {
    public static func from(json: AnyObject) throws -> Self {
        guard let value = json as? NSArray else {
            throw DeserializeError.typeMismatch
        }

        return self.init(array: value as [AnyObject])
    }
}

extension Set: Deserialize {
    public static func from(json: AnyObject) throws -> Set {
        guard let value = json as? NSArray else {
            throw DeserializeError.typeMismatch
        }

        return try Set(value.map { try deserialize($0 as AnyObject) })
    }
}

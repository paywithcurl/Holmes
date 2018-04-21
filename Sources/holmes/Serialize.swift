import Foundation
import CoreGraphics

public protocol Serialize {
    func toJSON() throws -> AnyObject
}

extension NSNull: Serialize {
    public func toJSON() throws -> AnyObject {
        return self
    }
}

extension Optional: Serialize {
    public func toJSON() throws -> AnyObject {
        if let value = self {
            if let obj = value as AnyObject as? Serialize {
                return try obj.toJSON()
            } else {
                throw SerializeError.optionalWrappedValueNotSerializable
            }
        } else {
            return NSNull()
        }
    }
}
                          
extension NSNumber: Serialize {
    public func toJSON() throws -> AnyObject {
        return self
    }
}

extension Bool: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Int: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Int8: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Int16: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Int32: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Int64: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension UInt: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension UInt8: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension UInt16: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension UInt32: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension UInt64: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Float: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension Double: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension CGFloat: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSNumber
    }
}

extension String: Serialize {
    public func toJSON() throws -> AnyObject {
        return self as NSString
    }
}
                 
extension NSString: Serialize {
    public func toJSON() throws -> AnyObject {
        return self
    }
}

extension NSArray: Serialize {
    public func toJSON() throws -> AnyObject {
        let elements: [Any] = try self.map {
            guard let elem = $0 as AnyObject as? Serialize else {
                throw SerializeError.arrayItemNotSerializable
            }

            return try elem.toJSON()
        }
        return elements as NSArray
    }
}

extension Array: Serialize {
    public func toJSON() throws -> AnyObject {
        let elements: [Any] = try self.map {
            guard let elem = $0 as AnyObject as? Serialize else {
                throw SerializeError.arrayItemNotSerializable
            }

            return try elem.toJSON()
        }
        return elements as NSArray
    }
}

extension NSDictionary: Serialize {
    public func toJSON() throws -> AnyObject {
        var newDict: [NSString: AnyObject] = [:]

        for (key, val) in self {
            guard let newKey = (key as? NSString) ?? (key as? String as NSString?) else {
                throw SerializeError.dictionaryKeyNotString
            }
            guard let newVal = val as AnyObject as? Serialize else {
                throw SerializeError.dictionaryValueNotSerializable
            }

            newDict[newKey] = try newVal.toJSON()
        }

        return newDict as NSDictionary as AnyObject
    }
}
                          
extension Dictionary: Serialize {
    public func toJSON() throws -> AnyObject {
        var newDict: [NSString: AnyObject] = [:]

        for (key, val) in self {
            guard let newKey = (key as? NSString) ?? (key as? String as NSString?) else {
                throw SerializeError.dictionaryKeyNotString
            }
            guard let newVal = val as AnyObject as? Serialize else {
                throw SerializeError.dictionaryValueNotSerializable
            }

            newDict[newKey] = try newVal.toJSON()
        }

        return newDict as NSDictionary as AnyObject
    }
}

extension UUID: Serialize {
    public func toJSON() throws -> AnyObject {
        return self.uuidString.lowercased() as AnyObject
    }
}

extension Date: Serialize {
    public func toJSON() throws -> AnyObject {
        return DateFormatter.rfc3339.string(from: self) as AnyObject
    }
}

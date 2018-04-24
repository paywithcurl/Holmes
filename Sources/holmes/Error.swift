import Foundation

public enum SerializeError: Error {
    case optionalWrappedValueNotSerializable
    case arrayItemNotSerializable
    case dictionaryValueNotSerializable
    case dictionaryKeyNotString
    case custom(message: String)
}

extension SerializeError: CustomNSError {
    public static let errorDomain = "com.paywithcurl.holmes.serializeError"
    
    public var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: description]
    }
}
                          
extension SerializeError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .optionalWrappedValueNotSerializable:
            return "Wrapped value of Optional does not conform to `Serialize`"
        case .arrayItemNotSerializable:
            return "Array item does does not conform to `Serialize`"
        case .dictionaryValueNotSerializable:
            return "Dictionary value does not conform to `Serialize`"
        case .dictionaryKeyNotString:
            return "Dictionary key is not a `String` or `NSString`"
        case .custom(let message):
            return "Serialization error: \(message)"
        }
    }
}

public enum DeserializeError: Error {
    case typeMismatch
    case notDeserializable
    case structNotDictionaryRepr
    case enumNotStringRepr(enumName: String)
    case unknownVariant(enumName: String, variantName: String)
    case custom(message: String)
}

extension DeserializeError: CustomNSError {
    public static let errorDomain = "com.paywithcurl.holmes.deserializeError"
    
    public var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: description]
    }
}
                          
extension DeserializeError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .typeMismatch:
            return "Value to be deserialized has the wrong type"
        case .notDeserializable:
            return "Type is not deserializable"
        case .structNotDictionaryRepr:
            return "Tried to deserialize struct or class from a non-`Dictionary` representation"
        case .enumNotStringRepr(let enumName):
            return "Tried to deserialize `enum \(enumName)` from a non-`String` representation"
        case .unknownVariant(let enumName, let variantName):
            return "Unknown variant: `\(enumName).\(variantName)`"
        case .custom(let message):
            return "Deserialization error: \(message)"
        }
    }
}

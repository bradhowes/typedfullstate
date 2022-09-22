// Copyright © 2022 Brad Howes. All rights reserved.

import AudioToolbox.AUParameters

/**
 Enumeration of supported types when converting from an Any
 */
public enum TypedAny: Codable {
  /// String value
  case string(value: String)
  /// Int/Int64 value
  case int(value: Int)
  /// Double value
  case double(value: Double)
  /// AUValue/Float value
  case auValue(value: AUValue)
  /// Data value
  case data(value: Data)
  /// Dict value
  case dict(value: [String: TypedAny])
  /// Array value
  case array(value: [TypedAny])

  /**
   Construct a new TypedAny from an Any value

   - parameter rawValue: the value to wrap
   - throws `invalidType` if unsupported type
   */
  public init(rawValue: Any) throws {
    switch rawValue {
    case let value as String: self = .string(value: value)
    case let value as Int: self = .int(value: value)
    case let value as Double: self = .double(value: value)
    case let value as AUValue: self = .auValue(value: value)
    case let value as Data: self = .data(value: value)
    case let value as [String: Any]: self = try .dict(value: value.mapValues { try TypedAny(rawValue: $0) })
    case let value as [Any]: self = try .array(value: value.map { try TypedAny(rawValue: $0) })
    default: throw TypedAnyError.invalidType
    }
  }
}

public extension TypedAny {

  /**
   Convert a Double into a String

   - parameter value: the Double to convert
   - returns: the String representation
   */
  static func formatted(_ value: Double) -> String { String(format: "%.16f", value) }

  /**
   Convert a AUValue into a string

   - parameter value: the AUValue to convert
   - returns: the String representation
   */
  static func formatted(_ value: AUValue) -> String { String(format: "%.16f", value) }
}

public extension TypedAny {

  /// Obtain the type name for the wrapped value
  var typeName: String {
    switch self {
    case .string: return "String"
    case .int: return "Int"
    case .double: return "Double"
    case .auValue: return "AUValue"
    case .data: return "Data"
    case .dict: return "Dict"
    case .array: return "Array"
    }
  }

  /// Obtain the String representation of the wrapped value
  var asString: String {
    switch self {
    case .string(value: let value): return value
    case .int(value: let value): return "\(value)"
    case .double(value: let value): return Self.formatted(value)
    case .auValue(value: let value): return Self.formatted(value)
    case .data(value: let value): return "<Data: \(value.count) bytes>"
    case .dict(value: let value):
      let items = value.map { "'\($0.0)': \($0.1.asString)" }
      return "{" + items.joined(separator: ",") + "}"
    case .array(value: let value):
      let items = value.map { "\($0.asString)" }
      return "[" + items.joined(separator: ",") + "]"
    }
  }

  /// Type-erase to Any
  var asAny: Any {
    switch self {
    case .string(value: let value): return value
    case .int(value: let value): return value
    case .double(value: let value): return value
    case .auValue(value: let value): return value
    case .data(value: let value): return value
    case .dict(value: let value): return value.mapValues { $0.asAny }
    case .array(value: let value): return value.map { $0.asAny }
    }
  }
}

public extension TypedAny {

  /// Convert to an Int if possible
  var asInt: Int? {
    if case .int(value: let value) = self { return value }
    return nil
  }

  /// Convert to a Double if possible
  var asDouble: Double? {
    if case .double(value: let value) = self { return value }
    return nil
  }

  /// Convert to an AUValue if possible
  var asAUValue: AUValue? {
    if case .auValue(value: let value) = self { return value }
    return nil
  }

  var asData: Data? {
    if case .data(value: let value) = self { return value }
    return nil
  }

  var asDict: [String: TypedAny]? {
    if case .dict(value: let value) = self { return value }
    return nil
  }

  var asArray: [TypedAny]? {
    if case .array(value: let value) = self { return value }
    return nil
  }
}

extension TypedAny: CustomDebugStringConvertible {
  public var debugDescription: String { "<TypedAny: \(self.typeName) - \(self.asString)>" }
}

extension TypedAny: Equatable {}

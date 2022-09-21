// Copyright © 2022 Brad Howes. All rights reserved.

/// Collection of optional FullState values
public typealias FullStateCollection = [FullState?]

public extension FullStateCollection {

  /**
   Obtain the TypedFullStateCollection equivalent of a FullStateCollection collection.

   - returns: the TypedFullStateCollection instance
   - throws `invalidType` if collection contains unsupported type
   */
  func asTypedAny() throws -> TypedFullStateCollection { try self.map { try $0?.asTypedAny() } }

  /**
   Create new FullStateCollection instance from a TypeFullStateCollection value.

   - parameter from: the value to convert
   - returns: new FullStateCollection instance
   */
  static func make(from: TypedFullStateCollection) -> Self { from.map { FullState.make(from: $0) } }
}

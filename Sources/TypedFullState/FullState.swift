// Copyright © 2022 Brad Howes. All rights reserved.

/// Type of container obtained from the AudioUnit fullState property
public typealias FullState = [String: Any]

public extension FullState {

  /**
   Obtain the TypedFullState equivalent of a FullState container.

   - returns: the TypeFullState representation
   - throws `invalidType` if we contain an unsupported type
   */
  func asTypedAny() throws -> TypedFullState { try self.mapValues { try TypedAny(rawValue: $0) } }

  /**
   Create new FullState instance from a TypedFullState value.

   - parameter from: the value to convert
   - returns: new FullState instance or nil if given value was nil
   */
  static func make(from: TypedFullState?) -> Self? { from?.mapValues { $0.asAny } ?? nil }
}

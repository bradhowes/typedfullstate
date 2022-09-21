# TypedFullState

This is a type-safe container for values stored in an AUv3
[fullState](https://developer.apple.com/documentation/audiotoolbox/auaudiounit/1387500-fullstate)
attribute of an AUAudioUnit entity. This attribute is defined to be a dictionary of `String` keys and `Any` values. The
[TypeFullState](Sources/TypedFullState/TypedFullState.swift) dictionary is a dictionary of `String` keys and `TypedAny` 
values, which is an enum of supported types.
 # Usage
 
Here's a simple example of moving from `AUAudioUnit.fullState` attribute to a typed representation, conversion 
to/from JSON and finally setting the same attribute with a typed representation:
 
```
let state = sampler.auAudioUnit.fullState!
let typedState = try! state.asTypedAny()
let encoded = try! JSONEncoder().encode(typedState)
...
let decoded = try! JSONDecoder().decode(TypedFullState.self, from: encoded)
let fullState = FullState.make(from: decoded)!
sampler.auAudioUnit.fullState = fullState
```

The types that are currently supported for values are:

* String
* Int
* Double
* Float (AUValue)
* Data
* Dictionary ([String: TypedAny])
* Array ([TypedAny])

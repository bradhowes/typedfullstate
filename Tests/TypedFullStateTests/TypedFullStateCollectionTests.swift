import AudioToolbox
import XCTest
import AVFAudio
import TypedFullState

class TypedFullStateCollectionTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testFullStateJSONEncodedDecoded() throws {
    let sampler = AVAudioUnitSampler()
    let state = sampler.auAudioUnit.fullState!
    let typedState = try! state.asTypedAny()
    let encoded = try! JSONEncoder().encode(typedState)
    let decoded = try! JSONDecoder().decode(TypedFullState.self, from: encoded)
    let fullState = FullState.make(from: decoded)!
    sampler.auAudioUnit.fullState = fullState
    XCTAssertEqual(state.count, fullState.count)
    XCTAssertEqual(state.keys.sorted(), fullState.keys.sorted())
  }

  func testFullStateCollectionConversions() throws {
    let a: FullState = ["one": 1, "two": 2.3, "three": AUValue(3.14159), "four": "4"]
    let b: FullState = ["five": 5.5, "six": 6]
    let c = [a, nil, nil, b]
    let d = try c.asTypedAny()
    XCTAssertEqual(d.count, c.count)
    XCTAssertEqual(d[0], try c[0]?.asTypedAny())
    XCTAssertEqual(d[1], nil)
    XCTAssertEqual(d[2], nil)
    XCTAssertEqual(d[3], try c[3]?.asTypedAny())

    let e = FullStateCollection.make(from: d)
    XCTAssertEqual(e.count, d.count)
    XCTAssertEqual(e[0]?["one"] as? Int, 1)
    XCTAssertEqual(e[0]?["two"] as? Double, 2.3)
    XCTAssertEqual(e[0]?["three"] as? AUValue, 3.14159)
    XCTAssertEqual(e[0]?["four"] as? String, "4")
    XCTAssertNil(e[1])
    XCTAssertNil(e[2])
    XCTAssertEqual(e[3]?["five"] as? Double, 5.5)
    XCTAssertEqual(e[3]?["six"] as? Int, 6)
  }
}

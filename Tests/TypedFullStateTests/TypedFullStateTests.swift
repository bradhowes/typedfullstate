import AudioToolbox
import XCTest
import AVFAudio
import TypedFullState

class TypedFullStateTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testFullState() {
    let a: TypedFullState = ["one": try! TypedAny(rawValue: 1), "two": try! TypedAny(rawValue: 2.0)]
    XCTAssertEqual(a.count, 2)
  }
}

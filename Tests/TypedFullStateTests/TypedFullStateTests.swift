import AudioToolbox
import XCTest
import AVFAudio
import TypedFullState

class TypedFullStateTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testTypedAnyAUValue() throws {
    let a = AUValue(1.23)
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual(b.asAUValue, a)
    XCTAssertEqual(b.asString, TypedAny.formatted(a))
  }

  func testTypedAnyString() throws {
    let a = "hello"
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual(b.asAny as! String, a)
    XCTAssertEqual(b.asString, a)
  }

  func testTypedAnyInt() throws {
    let a = 123
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual(b.asInt, a)
    XCTAssertEqual(b.asString, "\(a)")
  }

  func testTypedAnyDouble() throws {
    let a = Double(1.2345)
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual(b.asDouble, a)
    XCTAssertEqual(b.asString, TypedAny.formatted(a))
  }

  func testTypedAnyDict() throws {
    let a: [String: Any] = ["int": Int(1), "double": Double(1.2345), "string": "string"]
    let b = (try! TypedAny(rawValue: a)).asDict!
    XCTAssertEqual(b["int"]!.asInt, a["int"]! as? Int)
    XCTAssertEqual(b["double"]!.asDouble, a["double"]! as? Double)
    XCTAssertEqual(b["string"]!.asString, a["string"]! as? String)
  }

  func testTypedAnyArray() throws {
    let a: [Any] = [Int(1), Double(1.2345), "string", [1, 2, 3]]
    let b = (try! TypedAny(rawValue: a)).asArray!
    XCTAssertEqual(b[0].asInt, a[0] as? Int)
    XCTAssertEqual(b[1].asDouble, a[1] as? Double)
    XCTAssertEqual(b[2].asString, a[2] as? String)
    XCTAssertEqual(b[3].asArray, try? TypedAny(rawValue: a[3]).asArray)
  }
}

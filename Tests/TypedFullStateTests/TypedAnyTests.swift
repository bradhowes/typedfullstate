import AudioToolbox
import XCTest
import AVFAudio
import TypedFullState

class TypedAnyTests: XCTestCase {

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  func testInvalidType() throws {
    XCTAssertThrowsError(try TypedAny(rawValue: Date()))
  }

  func testTypedAnyAUValue() throws {
    let a = AUValue(1.23)
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual("AUValue", b.typeName)
    XCTAssertEqual(b.asAUValue, a)
    XCTAssertEqual(b.asString, TypedAny.formatted(a))
    XCTAssertEqual(b.asAny as! AUValue, a)
    XCTAssertNil(b.asInt)
    XCTAssertNil(b.asDouble)
    XCTAssertNil(b.asData)
    XCTAssertNil(b.asDict)
    XCTAssertNil(b.asArray)
  }

  func testTypedAnyString() throws {
    let a = "hello"
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual("String", b.typeName)
    XCTAssertEqual(b.asString, a)
    XCTAssertEqual(b.asAny as! String, a)
    XCTAssertNil(b.asAUValue)
    XCTAssertEqual(b.debugDescription, "<TypedAny: String - hello>")
  }

  func testTypedAnyInt() throws {
    let a = 123
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual("Int", b.typeName)
    XCTAssertEqual(b.asInt, a)
    XCTAssertEqual(b.asString, "\(a)")
    XCTAssertEqual(b.asAny as! Int, a)
  }

  func testTypedAnyDouble() throws {
    let a = Double(1.2345)
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual("Double", b.typeName)
    XCTAssertEqual(b.asDouble, a)
    XCTAssertEqual(b.asString, TypedAny.formatted(a))
    XCTAssertEqual(b.asAny as! Double, a)
  }

  func testTypedAnyDict() throws {
    let a: [String: Any] = ["int": Int(1), "double": Double(1.2345), "string": "string"]
    let b = try! TypedAny(rawValue: a)
    let c = b.asDict!
    XCTAssertEqual("Dict", b.typeName)
    XCTAssertEqual(b.asString.count, 56)
    XCTAssertEqual(c["int"]!.asInt, a["int"]! as? Int)
    XCTAssertEqual(c["double"]!.asDouble, a["double"]! as? Double)
    XCTAssertEqual(c["string"]!.asString, a["string"]! as? String)
    XCTAssertNotNil(b.asAny)
  }

  func testTypedAnyArray() throws {
    let a: [Any] = [Int(1), Double(1.2345), "string", [1, 2, 3]]
    let b = try! TypedAny(rawValue: a)
    let c = b.asArray!
    XCTAssertEqual("Array", b.typeName)
    XCTAssertEqual(b.asString, "[1,1.2344999999999999,string,[1,2,3]]")
    XCTAssertEqual(c[0].asInt, a[0] as? Int)
    XCTAssertEqual(c[1].asDouble, a[1] as? Double)
    XCTAssertEqual(c[2].asString, a[2] as? String)
    XCTAssertEqual(c[3].asArray, try? TypedAny(rawValue: a[3]).asArray)
    XCTAssertNotNil(b.asAny)
  }

  func testTypedAnyData() throws {
    let a = "bar".data(using: .utf8)!
    let b = try! TypedAny(rawValue: a)
    XCTAssertEqual("Data", b.typeName)
    XCTAssertEqual(b.asData, a)
    XCTAssertEqual(b.asString, "<Data: 3 bytes>")
    XCTAssertEqual(b.asAny as! Data, a)
  }
}

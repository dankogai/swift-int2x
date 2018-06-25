import XCTest
@testable import Int2X

final class Int2XTests: XCTestCase {
    func runShift<Q:FixedWidthInteger>(forType T:Q.Type) {
        let ua = Int2XConfig.useAccelerate ? [false, true] : [false]
        for a in [false, true] {
            if 1 < ua.count { Int2XConfig.useAccelerate = a }
            print("\(T.self) bitshift tests (Int2XConfig.useAccelerate = \(Int2XConfig.useAccelerate))")
            for x in [T.init(-1), T.init(+1)] {
                XCTAssertEqual(x << T.bitWidth, 0)
                var y = x
                for i in 0 ..< (T.bitWidth-1) {
                    // print("\(T.self)(\(x)) << \(i) == \(y)")
                    XCTAssertEqual(x << i, y, "\(i, x, y)")
                    // print("\(T.self)(\(y)) >> \(i) == \(x)")
                    XCTAssertEqual(y >> i, x, "\(i, x, y)")
                    y *= 2
                }
                XCTAssertEqual(y >> T.bitWidth, T.init(-1))
            }
        }
    }
    func testShiftInt128()  { runShift(forType:Int128.self) }
    func testShiftInt256()  { runShift(forType:Int256.self) }
    func testShiftInt512()  { runShift(forType:Int512.self) }
    // func testShiftInt1024() { runShift(forType:Int1024.self) }

    static var allTests = [
        ("testShiftInt128", testShiftInt128),
        ("testShiftInt256", testShiftInt256),
        ("testShiftInt512", testShiftInt512),
    ]
}

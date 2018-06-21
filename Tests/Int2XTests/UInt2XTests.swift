import XCTest
@testable import Int2X

extension UInt2X where Word == UInt8  {
    var asUInt:UInt {
        return (UInt(hi) << UInt8.bitWidth) + UInt(lo)
    }
}

final class UInt2XTests: XCTestCase {
    typealias U16 = UInt2X<UInt8>
    func testOp() {
        for v in 0 ..< UInt8.bitWidth * 2 {
            for u in 0 ..< UInt8.bitWidth * 2 {
                let x = UInt(1) << v - 1
                let y = UInt(1) << u - 1
                if x < 0x8000 && y < 0x8000 {
                    XCTAssertEqual(U16(x) + U16(y), U16(x + y))
                }
                if y <= x {
                    XCTAssertEqual(U16(x) - U16(y), U16(x - y))
                }
            }
        }
        for x in 0 ... UInt(UInt8.max) {
            for y in 0 ... UInt(UInt8.max) {
                XCTAssertEqual(U16(x) * U16(y), U16(x * y))
            }
        }
    }

    static var allTests = [
        ("testAdd", testOp),
    ]
}

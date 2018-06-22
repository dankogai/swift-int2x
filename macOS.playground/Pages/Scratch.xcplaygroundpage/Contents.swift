//: [Previous](@previous)

import Int2X

typealias U16 = UInt2X<UInt8>

var u16 = U16()
u16 == u16
u16.hashValue

u16 = 0xfedc

u16 + U16(1)
U16(0xFFFF).multipliedHalfWidth(by: 0xff)
U16(0xFFFF).multipliedFullWidth(by: 0xffff)
(U16(0xff) * U16(0xff))

U16(0xffff).quotientAndRemainder(dividingBy: U16(0x77e)).remainder

UInt16(0xffff).dividingFullWidth((high:UInt16(0xffff), low:UInt16(0xffff)))
U16(0xffff).dividingFullWidth((high:U16(0xffff), low:U16(0xffff))).remainder.description

//U16(0xffff).dividingFullWidth((high:U16(0x7fff), low:U16(0xffff))).remainder

//U16(255) + U16(1)
//U16(0) - U16(0)
//

func fact<T:Numeric & Comparable & ExpressibleByIntegerLiteral>(_ n:T)->T {
    guard 0 < n else { return 1 }
    var i:T = 1
    var r:T = 1
    while i <= n {
        r *= i
        i += 1
    }
    return r
}

fact(UInt(20))

typealias U128 = UInt2X<UInt64>
var u128 = U128(UInt64.max) * U128(UInt64.max)
var foo =  U128()
foo = 0xffffff
u128 - foo
u128.quotientAndRemainder(dividingBy: U128(UInt64.max) * foo).remainder

fact(U128(UInt(34))).description

// typealias U256 = UInt2X<U128>

//: [Next](@next)

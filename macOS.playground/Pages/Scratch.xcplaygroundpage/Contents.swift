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

UInt16(0xffff).dividingFullWidth((high:UInt16(0xfffe), low:UInt16(0xffff)))
U16(0xffff).dividingFullWidth((high:U16(0xfffe), low:U16(0xffff)))

U16(255) + U16(1)
U16(0) - U16(0)
////

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

typealias U128 = UInt2X<UInt64>
var u128 = fact(U128(34))

typealias U256 = UInt2X<U128>
var u256 = fact(U256(57)).description

typealias U512 = UInt2X<U256>

var u512 = fact(U512(57)).description

////: [Next](@next)

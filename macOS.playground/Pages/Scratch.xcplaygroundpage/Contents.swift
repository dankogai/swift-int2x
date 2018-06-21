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

//U16(255) + U16(1)
//U16(0) - U16(0)
//

typealias U128 = UInt2X<UInt64>
(U128(UInt64.max)*U128(UInt64.max))


// typealias U256 = UInt2X<U128>

//: [Next](@next)

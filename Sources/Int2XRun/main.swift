import Int2X

typealias U16 = UInt2X<UInt8>

U16(0xFFFF).multipliedHalfWidth(by: 0xff)
U16(0xFFFF).multipliedFullWidth(by: 0xffff)


func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

typealias U128 = UInt2X<UInt64>
//var u128 = U128(hi:UInt64.max, lo:UInt64.max)
//
//print(u128)
//print(U128.max)

// typealias U128 = UInt2X<UInt64>
//u128 = fact(U128(34))

typealias U256 = UInt2X<U128>
//var u256 = fact(U256(57)).description
//print(u256)
typealias U512 = UInt2X<U256>

var u512 = fact(U512(57)).description
print(u512)

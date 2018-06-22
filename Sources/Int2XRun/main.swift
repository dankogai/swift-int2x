import Int2X

typealias U16 = UInt2X<UInt8>

var u16 = U16(2)
print(u16)
print(u16 * u16)
u16 = 0xfedc
dump(u16)

print(U16(hi:0,lo:1) == U16(hi:1,lo:1))


func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

typealias U128 = UInt2X<UInt64>
var u128 = U128(hi:UInt64.max, lo:UInt64.max)

print(u128)
print(U128.max)

typealias U256 = UInt2X<U128>

print("!!!!")
var u256 = U256(1)
print(u256)

import Int2X

typealias U16 = UInt2X<UInt8>

var u16 = U16(2)
print(u16)
print(u16 * u16)
u16 = 0xfedc
dump(u16)

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

typealias U128 = UInt2X<UInt64>
//let f34 = fact(U128(34))
//let f32 = fact(U128(32))
//// print(U128(0xffff) / U128(0xff))
//var v = f34 / f32
var v = U128(hi:UInt64.max, lo:UInt64.max)

print(v)
print(U128(UInt64.max))
print(v / U128(UInt64.max))

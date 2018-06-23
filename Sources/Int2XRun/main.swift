import Int2X

typealias U16 = UInt2X<UInt8>

//U16(0xFFFF).multipliedHalfWidth(by: 0xff)
//U16(0xFFFF).multipliedFullWidth(by: 0xffff)


func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1){ print($1); return $0 * $1 }
}

//print( fact(UInt512(97)) )
var u1024 = fact(UInt1024(128)).description
print(u1024)
//var u1024 = UInt1024(98)
//dump(u1024)
//print(UInt1024(98))
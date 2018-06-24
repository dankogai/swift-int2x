import Int2X

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}
//for flag in [true, false] {
//Int2XConfig.useAccelerate = flag
//    print( Int128.max.dividingFullWidth((high:Int128.max>>1,low:UInt128.max)) )
//    print( Int128.max.quotientAndRemainder(dividingBy: Int128(UInt64.max)) )
//}
//for flag in [true, false] {
//    Int2XConfig.useAccelerate = flag
//    let v = fact(Int512(97)) / fact(Int512(56))
//    print(v)
//}

print( fact(Int256(56)) )
print( fact(Int256(21)) )
for flag in [true, false] {
    Int2XConfig.useAccelerate = flag
    let v = fact(Int256(56)) / fact(Int256(21))
    print(v.debugDescription)
}
//Int2XConfig.useAccelerate = true
//print(Int256("710998587804863451854045647463724949736497978881168458687447040000000000000") / "51090942171709440000")

////print(fact(U2048(300)))

//Int2XConfig.useAccelerate = false
//let imax = 56
//let factmax = fact(Int256(imax))
//var dummy = factmax
//print(factmax)
//for _ in (0..<1) {
//    for i in (0 ... imax) {
//        dummy = (factmax / fact(Int256(i)))
//        print(i, dummy)
//    }
//}
//print(dummy)

import Int2X

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

//for flag in [true, false] {
//    Int2XConfig.useAccelerate = flag
//    let v = fact(Int512(97)) / fact(Int512(56))
//    print(v)
//}

for flag in [true, false] {
    Int2XConfig.useAccelerate = flag
    let v = fact(Int256(56)) / fact(Int256(21))
    print(v)
}


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

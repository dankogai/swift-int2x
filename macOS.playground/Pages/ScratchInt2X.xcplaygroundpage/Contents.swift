//: [Previous](@previous)

import Int2X

typealias I16 = Int2X<UInt8>

//dump(I16(-1))
//dump(I16.max)
//dump(I16.min)
I16(-1).rawValue.hi.leadingZeroBitCount == 0
I16(-1).isNegative
I16(+1).isNegative
I16(-1).magnitude
I16(-1) < I16(0)

I16(+1) * I16(+1)
I16(-1) * I16(+1)
I16(+1) * I16(-1)
I16(-1) * I16(-1)
I16(+42).quotientAndRemainder(dividingBy: I16(+5)).quotient
I16(-42).quotientAndRemainder(dividingBy: I16(+5)).quotient
I16(+42).quotientAndRemainder(dividingBy: I16(-5)).quotient
I16(-42).quotientAndRemainder(dividingBy: I16(-5)).quotient
I16(+42).quotientAndRemainder(dividingBy: I16(+5)).remainder
I16(-42).quotientAndRemainder(dividingBy: I16(+5)).remainder
I16(+42).quotientAndRemainder(dividingBy: I16(-5)).remainder
I16(-42).quotientAndRemainder(dividingBy: I16(-5)).remainder
I16(+42).asInt
I16(-42).asInt
(I16(0)..<I16(8))[4]

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1, *)
}

fact(Int128(34))

//: [Next](@next)

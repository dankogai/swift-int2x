import Int2X

typealias U2048 = UInt2X<UInt1024>

func fact<T:FixedWidthInteger>(_ n:T)->T {
    return n == 0 ? 1 : (1...Int(n)).map{ T($0) }.reduce(1){ print($1) ; return $0 * $1 }
}

print(fact(U2048(300)))

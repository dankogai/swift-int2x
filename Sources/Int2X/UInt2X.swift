public typealias UInt1X = FixedWidthInteger & BinaryInteger & UnsignedInteger & Codable

public struct UInt2X<Word:UInt1X>: Hashable, Codable {
    public typealias IntegerLiteralType = UInt
    public typealias Magnitude = UInt2X
    public typealias Words = [Word.Words.Element]
    public typealias Stride = Int
    public var hi:Word = 0
    public var lo:Word = 0
    public init(hi:Word, lo:Word) { (self.hi, self.lo) = (hi, lo) }
    public init(_ source:UInt2X){ (hi, lo) = (source.hi, source.lo) }
}
// address auto equatability bug of Swift 4.1 :-(
extension UInt2X {
    public static func ==(_ lhs:UInt2X, _ rhs:UInt2X)->Bool {
        return lhs.hi == rhs.hi && lhs.lo == rhs.lo
    }
}
// initializers & Constants
extension UInt2X : ExpressibleByIntegerLiteral {
    public static var isSigned: Bool { return false }
    public static var min:UInt2X { return UInt2X(hi:Word.min, lo:Word.min) }
    public static var max:UInt2X { return UInt2X(hi:Word.max, lo:Word.max) }
    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard Word.bitWidth * 2 <= source.bitWidth else { return nil }
        self.hi = Word(source >> Word.bitWidth)
        self.lo = Word(source == 0 ? 0 : source & T(clamping:Word.max))
    }
    public init<T>(_ source: T) where T : BinaryInteger  {
        if source is Int {
            self.hi = Word(source.magnitude >> Word.bitWidth)
            self.lo = Word(clamping:source.magnitude)
        } else {
            self.hi = Word(source >> Word.bitWidth)
            self.lo = Word(source & T(clamping:Word.max))
        }
    }
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        return nil
    }
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.init(UInt(source))
    }
    public init<T:BinaryInteger>(truncatingIfNeeded source: T) {
        if source is Int {
            self.hi = Word(source.magnitude >> Word.bitWidth)
            self.lo = Word(clamping:source.magnitude)
        } else {
            self.hi = Word(source >> Word.bitWidth)
            self.lo = Word(source & T(clamping:Word.max))
        }
    }
    public init<T:BinaryInteger>(clamping source: T) {
        if source is Int {
            self.hi = Word(source.magnitude >> Word.bitWidth)
            self.lo = Word(clamping:source.magnitude)
        } else {
            self.hi = Word(source >> Word.bitWidth)
            self.lo = Word(source & T(clamping:Word.max))
        }
    }
    public init(integerLiteral value: UInt) {
        self.init(value)
    }
}
// Comparable
extension UInt2X : Comparable {
    public static func < (lhs: UInt2X, rhs: UInt2X) -> Bool {
        return lhs.hi < rhs.hi ? true : lhs.hi == rhs.hi && lhs.lo < rhs.lo
    }
}
// numeric
extension UInt2X : Numeric {
   public var magnitude: UInt2X {
        return UInt2X(hi:self.hi, lo:self.lo)
    }
    // unary operators
    public static prefix func ~(_ value:UInt2X)->UInt2X {
        return UInt2X(hi:~value.hi, lo:~value.lo)
    }
    public static prefix func +(_ value:UInt2X)->UInt2X {
        return value
    }
    public static prefix func -(_ value:UInt2X)->UInt2X {
        return ~value &+ 1  // two's complement
    }
    // additions
    public func addingReportingOverflow(_ other: UInt2X) -> (partialValue: UInt2X, overflow: Bool) {
        var of = false
        let (lv, lf) = self.lo.addingReportingOverflow(other.lo)
        var (hv, uo) = self.hi.addingReportingOverflow(other.hi)
        if lf {
            (hv, of) = hv.addingReportingOverflow(1)
        }
        return (partialValue: UInt2X(hi:hv, lo:lv), overflow: uo || of)
    }
    public func addingReportingOverflow(_ other: Word) -> (partialValue: UInt2X, overflow: Bool) {
        return self.addingReportingOverflow(UInt2X(hi:0, lo:other))
    }
    public static func &+(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        return lhs.addingReportingOverflow(rhs).partialValue
    }
    public static func +(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        precondition(~lhs >= rhs, "\(lhs) + \(rhs): Addition overflow!")
        return lhs &+ rhs
    }
    public static func +(_ lhs:UInt2X, _ rhs:Word)->UInt2X {
        return lhs + UInt2X(hi:0, lo:rhs)
    }
    public static func +(_ lhs:Word, _ rhs:UInt2X)->UInt2X {
        return UInt2X(hi:0, lo:lhs) + rhs
    }
    public static func += (lhs: inout UInt2X, rhs: UInt2X) {
        lhs = lhs + rhs
    }
    public static func += (lhs: inout UInt2X, rhs: Word) {
        lhs = lhs + rhs
    }
    // subtraction
    public func subtractingReportingOverflow(_ other: UInt2X) -> (partialValue: UInt2X, overflow: Bool) {
        return self.addingReportingOverflow(-other)
    }
    public func subtractingReportingOverflow(_ other: Word) -> (partialValue: UInt2X, overflow: Bool) {
        return self.subtractingReportingOverflow(UInt2X(hi:0, lo:other))
    }
    public static func &-(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        return lhs.subtractingReportingOverflow(rhs).partialValue
    }
    public static func -(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        precondition(lhs >= rhs, "\(lhs) - \(rhs): Subtraction overflow!")
        return lhs &- rhs
    }
    public static func -(_ lhs:UInt2X, _ rhs:Word)->UInt2X {
        return lhs - UInt2X(hi:0, lo:rhs)
    }
    public static func -(_ lhs:Word, _ rhs:UInt2X)->UInt2X {
        return UInt2X(hi:0, lo:lhs) - rhs
    }
    public static func -= (lhs: inout UInt2X, rhs: UInt2X) {
        lhs = lhs - rhs
    }
    public static func -= (lhs: inout UInt2X, rhs: Word) {
        lhs = lhs - rhs
    }
    // multiplication
    public func multipliedHalfWidth(by other: Word) -> (high: UInt2X, low: Magnitude) {
        let l = self.lo.multipliedFullWidth(by:other)
        let h = self.hi.multipliedFullWidth(by:other)
        let r0          = Word(l.low)
        let (r1, o1)    = Word(h.low).addingReportingOverflow(Word(l.high))
        let r2          = Word(h.high) &+ (o1 ? 1 : 0)  // will not overflow
        return (UInt2X(hi:0, lo:r2), UInt2X(hi:r1, lo:r0))
    }
    public func multipliedFullWidth(by other: UInt2X) -> (high: UInt2X, low: Magnitude) {
        let l  = self.multipliedHalfWidth(by: other.lo)
        let hs = self.multipliedHalfWidth(by: other.hi)
        let h  = (high:UInt2X(hi:hs.high.lo, lo:hs.low.hi), low:UInt2X(hi:hs.low.lo, lo:0))
        let (rl, ol) = h.low.addingReportingOverflow(l.low)
        let rh       = h.high &+ l.high &+ (ol ? 1 : 0) // will not overflow
        return (rh, rl)
    }
    public func multipliedReportingOverflow(by other: UInt2X) -> (partialValue: UInt2X, overflow: Bool) {
        let result = self.multipliedFullWidth(by: other)
        return (result.low, 0 < result.high)
    }
    public static func &*(lhs: UInt2X, rhs: UInt2X) -> UInt2X {
        return lhs.multipliedReportingOverflow(by: rhs).partialValue
    }
    public static func &*(lhs: UInt2X, rhs: Word) -> UInt2X {
        return lhs.multipliedHalfWidth(by: rhs).low
    }
    public static func &*(lhs: Word, rhs: UInt2X) -> UInt2X {
        return rhs.multipliedHalfWidth(by: lhs).low
    }
    public static func *(lhs: UInt2X, rhs: UInt2X) -> UInt2X {
        let result = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!result.overflow, "Multiplication overflow!")
        return result.partialValue
    }
    public static func *(lhs: UInt2X, rhs: Word) -> UInt2X {
        let result = lhs.multipliedHalfWidth(by: rhs)
        precondition(result.high == 0, "Multiplication overflow!")
        return result.low
    }
    public static func *(lhs: Word, rhs: UInt2X) -> UInt2X {
        let result = rhs.multipliedHalfWidth(by: lhs)
        precondition(result.high == 0, "Multiplication overflow!")
        return result.low
    }
    public static func *= (lhs: inout UInt2X, rhs: UInt2X) {
        lhs = lhs * rhs
    }
    public static func *= (lhs: inout UInt2X, rhs: Word) {
        lhs = lhs * rhs
    }
}
// bitshifts
extension UInt2X {
    public func rShifted(_ width:Int)->UInt2X {
        if width <  0 { return self.lShifted(-width) }
        if width == 0 { return self }
        if width == Word.bitWidth     { return UInt2X(hi:0, lo:self.hi) }
        if Word.bitWidth < width {
            return UInt2X(hi:0, lo:self.lo >> (width - Word.bitWidth))
        }
        else {
            let mask = Word((1 << width) - 1)
            let carry = (self.hi & mask) << (Word.bitWidth - width)
            return UInt2X(hi: self.hi >> width, lo: carry | self.lo >> width)
        }
    }
    public func lShifted(_ width:Int)->UInt2X {
        if width <  0 { return self.rShifted(-width) }
        if width == 0 { return self }
        if width == Word.bitWidth     { return UInt2X(hi:self.lo, lo:0) }
        if Word.bitWidth < width {
            return UInt2X(hi:self.lo << (width - Word.bitWidth), lo:0)
        }
        else {
            let carry = self.lo >> (Word.bitWidth - width)
            return UInt2X(hi: self.hi << width | carry, lo: self.lo << width)
        }
    }
    public static func &>>(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        return lhs.rShifted(Int(rhs.lo))
    }
    public static func &>>=(_ lhs:inout UInt2X, _ rhs:UInt2X) {
        return lhs = lhs &>> rhs
    }
    public static func &<<(_ lhs:UInt2X, _ rhs:UInt2X)->UInt2X {
        return lhs.lShifted(Int(rhs.lo))
    }
    public static func &<<=(_ lhs:inout UInt2X, _ rhs:UInt2X) {
        return lhs = lhs &<< rhs
    }

}
// division, which is rather tough
extension UInt2X {
    public func quotientAndRemainder(dividingBy other: Word) -> (quotient: UInt2X, remainder: UInt2X) {
        precondition(other != 0, "division by zero!")
        let (qh, rh) = self.hi.quotientAndRemainder(dividingBy: other)
        let (ql, rl) = other.dividingFullWidth((high: rh, low:self.lo.magnitude))
        return (UInt2X(hi:qh, lo:ql), UInt2X(rl))
    }
    public func quotientAndRemainder(dividingBy other: UInt2X) -> (quotient: UInt2X, remainder: UInt2X) {
        precondition(other != 0, "division by zero!")
        guard other != self else { return (1, 0) }
        guard other <  self else { return (0, self) }
        guard other.hi != 0 else {
            return self.quotientAndRemainder(dividingBy: other.lo)
        }
        #if false
        if Word.bitWidth * 2 <= UInt64.bitWidth { // cheat when we can :-)
            let divided = (UInt64(self.hi)  << Word.bitWidth) +  UInt64(self.lo)
            let divider = (UInt64(other.hi) << Word.bitWidth) + UInt64(other.lo)
            let (q, r) = divided.quotientAndRemainder(dividingBy: divider)
            return (UInt2X(q), UInt2X(r))
        }
        #endif
        let offset = Word.bitWidth - other.hi.leadingZeroBitCount
        var q = self.rShifted(offset)
            .quotientAndRemainder(dividingBy: other.rShifted(offset).lo).quotient
        var r = self - other * q
        // print("\(#line):(q, r) = (\(q), \(r))")
        while other < r {
            // print("\(#line):(q, r) = (\(q), \(r))")
            q += 1; r -= other
        }
        return (q, r)
    }
    public static func / (_ lhs:UInt2X, rhs:UInt2X)->UInt2X {
        return lhs.quotientAndRemainder(dividingBy: rhs).quotient
    }
    public static func /= (_ lhs:inout UInt2X, rhs:UInt2X) {
        lhs = lhs / rhs
    }
    public static func % (_ lhs:UInt2X, rhs:UInt2X)->UInt2X {
        return lhs.quotientAndRemainder(dividingBy: rhs).remainder
    }
    public static func %= (_ lhs:inout UInt2X, rhs:UInt2X) {
        lhs = lhs % rhs
    }
    public func dividedReportingOverflow(by other :UInt2X) -> (partialValue: UInt2X, overflow:Bool) {
        return (self / other, false)
    }
    public func remainderReportingOverflow(dividingBy other :UInt2X) -> (partialValue: UInt2X, overflow:Bool) {
        return (self % other, false)
    }
    public func dividingFullWidth(_ dividend: (high: UInt2X, low: Magnitude)) -> (quotient: UInt2X, remainder: UInt2X) {
        precondition(self != 0, "division by zero!")
        guard dividend.high != 0 else { return dividend.low.quotientAndRemainder(dividingBy: self) }
        // 3-word / 2-word division
        func qr3(dividend:(Word, Word, Word), divider:UInt2X) -> (UInt2X, UInt2X) {
            if divider.hi == 0 {
                let (qh, rh) = UInt2X(hi:dividend.0, lo:dividend.1).quotientAndRemainder(dividingBy: divider.lo)
                let (ql, rl) = UInt2X(hi:rh.lo,      lo:dividend.2).quotientAndRemainder(dividingBy: divider.lo)
                return (UInt2X(hi:qh.lo, lo:ql.lo), rl)
            }
            else {
                var (q, r) = UInt2X(hi:dividend.0, lo:dividend.1).quotientAndRemainder(dividingBy: divider.hi)
                var t = divider.multipliedFullWidth(by: q)
                while UInt2X(hi:dividend.0, lo:dividend.1) < UInt2X(hi:t.high.lo, lo:t.low.hi) {
                    q -= 1
                    t = divider.multipliedFullWidth(by: q)
                }
                // Subtraction with carry considered.  Bummer.
                r = UInt2X(dividend.0 - t.high.lo)
                r = UInt2X(hi:r.lo, lo:dividend.1) - UInt2X(t.low.hi)
                r = UInt2X(hi:r.lo, lo:dividend.2) - UInt2X(t.low.lo)
                return (q, r)
            }
        }
        let (dh, dl) = (dividend.high % self, dividend.low)
        var (q0, q1, r):(UInt2X, UInt2X, UInt2X)
        (q0, r) = qr3(dividend:(dh.hi, dh.lo, dl.hi), divider:self)
        (q1, r) = qr3(dividend:( r.hi,  r.lo, dl.lo), divider:self)
        return (UInt2X(hi:q0.lo, lo:q1.lo), r)
    }
}
// stringification
extension UInt2X : CustomStringConvertible, CustomDebugStringConvertible {
    public func toString(radix: Int = 10, uppercase: Bool = false) -> String {
        precondition((2...36) ~= radix, "radix must be within the range of 2-36.")
        if self == 0 { return "0" }
        var result = [Character]()
        var qr = (quotient: self, remainder: UInt2X(0))
        let digits = uppercase
            ? Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            : Array("0123456789abcdefghijklmnopqrstuvwxyz")
        repeat {
            qr = qr.quotient.quotientAndRemainder(dividingBy: Word(radix))
            result.append(digits[Int(qr.remainder.lo)])
        } while qr.quotient != 0
        return String(result.reversed())
    }
    public var description:String {
        return toString()
    }
    public var debugDescription:String {
        return "0x" + toString(radix: 16)
    }
}
// Strideable
extension UInt2X: Strideable {
    public var asInt:Int {
        return Int(bitPattern:UInt(self.hi << Word.bitWidth + self.lo))
    }
    public func distance(to other: UInt2X) -> Int {
        return other.asInt - self.asInt
    }
    public func advanced(by n: Int) -> UInt2X {
        return self + UInt2X(n)
    }
}
extension UInt2X: BinaryInteger {
    public var bitWidth: Int {
        return Word.bitWidth * 2
    }
    public var words: Words {
        return Array(self.lo.words) + Array(self.hi.words)
    }
    public var trailingZeroBitCount: Int {
        return self.hi == 0 ? self.lo.trailingZeroBitCount : self.hi.trailingZeroBitCount + Word.bitWidth
    }
    public static func &= (lhs: inout UInt2X, rhs: UInt2X) {
        lhs = UInt2X(hi:lhs.hi & rhs.hi, lo:lhs.lo & rhs.lo)
    }
    public static func |= (lhs: inout UInt2X, rhs: UInt2X) {
        lhs = UInt2X(hi:lhs.hi | rhs.hi, lo:lhs.lo | rhs.lo)
    }
    public static func ^= (lhs: inout UInt2X<Word>, rhs: UInt2X<Word>) {
        lhs = UInt2X(hi:lhs.hi ^ rhs.hi, lo:lhs.lo ^ rhs.lo)
    }
    public static func <<= <RHS>(lhs: inout UInt2X<Word>, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs.lShifted(Int(rhs))
    }
    public static func >>= <RHS>(lhs: inout UInt2X, rhs: RHS) where RHS : BinaryInteger {
        lhs = lhs.rShifted(Int(rhs))
    }
}
extension UInt2X: FixedWidthInteger {
    public init(_truncatingBits bits: UInt) {
        fatalError()
    }
    public var nonzeroBitCount: Int {
        return self.hi.nonzeroBitCount + self.lo.nonzeroBitCount
    }
    public var leadingZeroBitCount: Int {
        return self.hi == 0 ? self.lo.leadingZeroBitCount + Word.bitWidth : self.hi.leadingZeroBitCount
    }
    public var byteSwapped: UInt2X {
        return UInt2X(hi:self.lo.byteSwapped, lo:self.hi.byteSwapped)
    }
    public static var bitWidth: Int {
        return Word.bitWidth * 2
    }
}
extension UInt2X: UnsignedInteger {}


public typealias UInt1X = FixedWidthInteger & BinaryInteger & UnsignedInteger & Codable

public struct UInt2X<Word:UInt1X>: Hashable, Codable {
    public typealias IntegerLiteralType = UInt
    public typealias Magnitude = UInt2X
    public var (hi, lo):(Word, Word)
    public init(hi:Word, lo:Word) { (self.hi, self.lo) = (hi, lo) }
    public init(_ source:UInt2X){ (hi, lo) = (source.hi, source.lo) }
    public init() { (hi, lo) = (0, 0) }
}
// initializers & Constants
extension UInt2X : ExpressibleByIntegerLiteral {
    public init<T>(exactly source: T) where T : BinaryInteger  {
        let h = source >> Word.bitWidth
        let l = source == 0 ? 0 : source  & T(Word.max)
        self.init(hi:Word(h), lo:Word(l))
    }
    public init<T>(_ source: T) where T : BinaryInteger  {
        let h = source == 0 ? 0 : source >> Word.bitWidth
        let l = source == 0 ? 0 : source  & T(Word.max)
        self.init(hi:Word(h), lo:Word(l))
    }
    public init(integerLiteral value: UInt) {
        self.init(value)
    }
    public static var min:UInt2X { return UInt2X(hi:Word.min, lo:Word.min) }
    public static var max:UInt2X { return UInt2X(hi:Word.max, lo:Word.max) }
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
//
extension UInt2X {
//    public static func >>(_ lhs: UInt2X, _ rhs: UInt2X)->UInt2X {
//        
//    }
    public func rightShifted(_ width:Int)->UInt2X {
        precondition(0 <= width)
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
    public func dividingFullWidth(_ dividend: (high: UInt2X, low: Magnitude)) -> (quotient: UInt2X, remainder: UInt2X) {
        fatalError()
    }
    public func quotientAndRemainder(dividingBy other: Word) -> (quotient: UInt2X, remainder: UInt2X) {
        precondition(other != 0, "division by zero!")
        let (qh, rh) = self.hi.quotientAndRemainder(dividingBy: other)
        let (ql, rl) = other.dividingFullWidth((high: rh, low:self.lo.magnitude))
        return (UInt2X(hi:qh, lo:ql), UInt2X(rl))
    }
    public func quotientAndRemainder(dividingBy other: UInt2X) -> (quotient: UInt2X, remainder: UInt2X) {
        precondition(other != 0, "division by zero!")
        guard self != other else { return (1, 0) }
        guard self > other else  { return (0, other) }
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
        var q = self.rightShifted(offset)
            .quotientAndRemainder(dividingBy: other.rightShifted(offset).lo).quotient
        var r = self - other * q
        // print("\(#line):(q, r) = (\(q), \(r))")
        while other < r {
            // print("\(#line):(q, r) = (\(q), \(r))")
            q += 1; r -= other
        }
        return (q, r)
    }
}

extension UInt2X : CustomStringConvertible, CustomDebugStringConvertible {
    public func toString(radix: Int = 10, uppercase: Bool = false) -> String {
        precondition((2...36) ~= radix, "radix must be within the range of 2-36.")
        if self == 0 { return "0" }
        var result = ""
        var qr = (quotient: self, remainder: UInt2X(0))
        let digits = uppercase
            ? "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            : "0123456789abcdefghijklmnopqrstuvwxyz"
        repeat {
            qr = qr.quotient.quotientAndRemainder(dividingBy: Word(radix))
            let index = digits.index(digits.startIndex, offsetBy: Int(qr.remainder.lo))
            result.insert(digits[index], at: result.startIndex)
        } while qr.quotient > 0
        return result
    }
    public var description:String {
        return toString()
    }
    public var debugDescription:String {
        return "0x" + toString(radix: 16)
    }
}

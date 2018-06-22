public struct Int2X<Word:UInt1X>: Hashable, Codable {
    public typealias IntegerLiteralType = Int
    public typealias Magnitude = UInt2X
    public typealias Stride = Int
    public var (hi, lo):(Word, Word)
    public init(hi:Word, lo:Word) { (self.hi, self.lo) = (hi, lo) }
    public init(_ source:Int2X){ (hi, lo) = (source.hi, source.lo) }
    public init() { (hi, lo) = (0, 0) }
}

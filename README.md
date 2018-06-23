[![Swift 4.1](https://img.shields.io/badge/swift-4.1-brightgreen.svg)](https://swift.org)
[![MIT LiCENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![build status](https://secure.travis-ci.org/dankogai/swift-int2x.png)](http://travis-ci.org/dankogai/swift-int2x)

# swift-int2x

Create Double-Width Integers with Ease

## Synopsis

```swift
import Int2X

typealias U128 = UInt2X<UInt64> // Yes.  That's it!
typealias I128 = Int2X<UInt64>  // ditto for signed integers
```

## Description

Thanks to [SE-0104], making your own integer types is easier than ever.  This module makes use of it -- creating double-width integer from any given [FixedWidthInteger].

[SE-0104]: https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md
[FixedWidthInteger]: https://developer.apple.com/documentation/swift/fixedwidthinteger

U?Int{128,256,512,1024} are predefined as follows:

```swift
public typealias UInt128    = UInt2X<UInt64>
public typealias UInt256    = UInt2X<UInt128>
public typealias UInt512    = UInt2X<UInt256>
public typealias UInt1024   = UInt2X<UInt512>
```

```swift
public typealias Int128    = Int2X<UInt64>
public typealias Int256    = Int2X<UInt128>
public typealias Int512    = Int2X<UInt256>
public typealias Int1024   = Int2X<UInt512>
```

As you see, `UInt2X` and `Int2X` themselves are [FixedWidthInteger] so you can stack them up.

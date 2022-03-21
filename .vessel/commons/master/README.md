# ic-commons

IC Commons, a package of Motoko utility classes for the classes.

  - [Base64](#base64)
  - [CRC32](#crc32)
  - [Hex](#hex)
  - [BitwiseNat](#bitwisenat)
  - [BitwiseInt](#bitwiseint)
  - [IntUtils](#intutils)
  - [NatUtils](#natutils)
  - [TextUtils](#textutils)
  - [CollectUtils](#collectutils)
  - [PrincipalUtils](#principalutils)

## Base64

### encode
___
```rust
func encode(value: Text) : Text
```
Encodes string by Base64.

## CRC32

### crc32
___
```rust
func crc32(value: [Nat8]) : [Nat8]
```
Encodes an array of Nat8 by CRC32, and return the encoded array.

### ofBlob
___
```rust
func ofBlob(blob: Blob) : Nat32
```
Encodes Blob convert into Nat32 by CRC32.

### ofArray
___
```rust
func ofArray(arr : [Nat8]) : Nat32
```
Encodes an array of Nat8 convert into Nat32 by CRC32.

## Hex

### encode
___
```rust
func encode(array: [Nat8]) : Text
```
Encodes an array of Nat8 by Hex, and return the encoded array.

### decode
___
```rust
func decode(text: Text) : async [Nat8]
```
Decodes string by Hex, and return the decoded Nat8 array.

### toHex
___
```rust
func toHex(_data: Text) : Text
```
Encodes string by Hex, and return the encoded string.

## BitwiseInt

### bitshiftLeft
___
```rust
func bitshiftLeft(x: Int, y: Int) : Int
```
The left shift operation, shifts x by y of bits to the left.

### bitshiftRight
___
```rust
func bitshiftRight(x: Int, y: Int) : Int
```
The right shift operation, shifts x by y of bits to the right.

### toIntArr
___
```rust
func toIntArr(x: Int, bit: Nat) : [Int64]
```
Converts x into a array of Int64 by bit number of bits.

### bitOperation
___
```rust
func bitOperation(x: Int, y: Int, operationFunc: (x1: Int64, y1: Int64) -> Int64) : Int
```
Performs bitwise operation on x and y via operationFunc function, and return the calculated result.

### bitand
___
```rust
func bitand(x: Int, y: Int) : Int
```
Bitwise AND operation on x and y.

### bitor
___
```rust
func bitor(x: Int, y: Int) : Int
```
Bitwise OR operation on x and y.

### bitnot
___
```rust
func bitnot(x: Int) : Int
```
Bitwise NOT operation on x and y.

## IntUtils

### toNat
___
```rust
func toNat(x: Int) : Nat
```
Converts the Int type of x into Nat.

## BitwiseNat

### bitshiftLeft
___
```rust
func bitshiftLeft(x: Nat, y: Nat) : Nat
```
The left shift operation, shifts x by y of bits to the left.

### bitshiftRight
___
```rust
func bitshiftRight(x: Nat, y: Nat) : Nat
```
The right shift operation, shifts x by y of bits to the right.

### toIntArr
___
```rust
func toIntArr(x: Nat, bit: Nat) : [Nat64]
```
Converts x into a array of Nat64 by bit number of bits.

### bitOperation
___
```rust
func bitOperation(x: Nat, y: Nat, operationFunc: (x1: Nat64, y1: Nat64) -> Int64) : Nat
```
Performs bitwise operation on x and y via operationFunc function, and return the calculated result.

### bitand
___
```rust
func bitand(x: Nat, y: Nat) : Nat
```
Bitwise AND operation on x and y.

### bitor
___
```rust
func bitor(x: Nat, y: Nat) : Nat
```
Bitwise OR operation on x and y.

### bitnot
___
```rust
func bitnot(x: Nat) : Nat
```
Bitwise NOT operation on x and y.

## NatUtils

### toInt
___
```rust
func toInt(x: Nat) : Int
```
Converts the Nat type of x into Int.

### nat32ToNat8Arr
___
```rust
func nat32ToNat8Arr(nat: Nat32) : [Nat8]
```
Converts nat of Nat32 into an array of Nat8.

### gt
___
```rust
func gt(x: Nat, y: Nat) : Nat
```
Compares x and y. If x greater than y, return 1, otherwise return 0.

### lt
___
```rust
func lt(x: Nat, y: Nat) : Nat
```
Compares x and y. If x lower than y, return 1, otherwise return 0.

### isZero
___
```rust
func isZero(v: Nat) : Bool
```
Checks if the v is zero.

## TextUtils

### encode
___
```rust
func encode(array: [Nat8]) : Text
```
Encodes an array of Nat8 by Base64, return the encoded string.

### fromInt
___
```rust
func fromInt(v: Int) : Text
```
Converts an Int number into string.

### fromNat
___
```rust
func fromNat(v: Nat) : Text
```
Converts an Nat number into string.

### fromNat8
___
```rust
func fromNat8(u8: Nat8) : Text
```
Converts an Nat8 number into string.

### toInt
___
```rust
func toInt(txt: Text) : Int
```
Converts a string into Int number.

### toNat
___
```rust
func toNat(text: Text) : Nat
```
Converts a string into Nat number.

### toUpperCase
___
```rust
func toUpperCase(text: Text) : Text
```
Return the calling string value converted to uppercase.

### equalsIgnoreCase
___
```rust
func equalsIgnoreCase(t1: Text, t2: Text) : Bool
```
Compares two strings without case sensitive.

### extractText
___
```rust
func extractText(t: Text, i: Nat, j: Nat) : Text
```
Returns the part of the string t between the start i and end j indexes.

### toArray
___
```rust
func toArray(t: Text) : [Text]
```
Divides a string t into each character of the string, puts these characters into an array, and returns the array.

### fromArray
___
```rust
func fromArray(array: [Text]) : Text
```
Returns a new string by concatenating all of the elements in an array.

### completionZero
___
```rust
func completionZero(_t: Text, d: DirectionType, n: Nat) : Text
```
Fills vacated bits with zeros before/after string _t by DirectionType type. The n is the length of the string which has been filled vacated bits with zeros

### binaryToDecimal
___
```rust
func binaryToDecimal(_num: Nat32) : Text
```
Converts a Nat32 number into a binary string.

### scaleToDecimal
___
```rust
func scaleToDecimal(number: Text, scale: Nat) : Nat
```
Converts a scale-ary string into a Nat number.

### hexToNumber
___
```rust
func hexToNumber(_t: Text) : Nat
```
Converts a Hex string into a Nat number.

## CollectUtils

### arrayContains
___
```rust
func arrayContains<T>(arr: [T], item: T, equal: (T, T) -> Bool) : Bool
```
Determines whether an array matchs a certain value among its entries, returning true or false as "equal" function returns.

### listRemove
___
```rust
func listRemove<T>(list: List.List<T>, item: T, equal: (T, T) -> Bool) : List.List<T>
```
Removes matched item in the list, returning the list which removed item.

### arrayRemove
___
```rust
func arrayRemove<T>(arr: [T], item: T, equal: (T, T) -> Bool) : [T]
```
Removes matched element in the array, returning the array which removed element.

### listRange
___
```rust
func listRange<T>(list: List.List<T>, offset: Nat, limit: Nat) : List.List<T>
```
Returns a portion of the list, starting at the offset index and extending for a given number of items afterwards.

### arrayRange
___
```rust
func arrayRange<T>(arr: [T], offset: Nat, limit: Nat) : [T]
```
Returns a portion of the array, starting at the offset index and extending for a given number of elements afterwards.

### sort
___
```rust
func sort<A>(xs : [A], cmp : (A, A) -> Order.Order) : [A]
```
Sorts the elements of an array and returns the sorted array. The sort order is determined by cmp function.

### sortInPlace
___
```rust
func sortInPlace<A>(xs : [var A], cmp : (A, A) -> Order.Order)
```
Sorts the elements of an array in place and returns the sorted array. The sort order is determined by cmp function.

## PrincipalUtils

### toAddress
___
```rust
func toAddress(p: Principal) : Text
```
Converts Principal into the Account Id string.

### blobToAddress
___
```rust
func blobToAddress(blob : Blob) : Text
```
Converts Blob into the Account Id string.

### toText
___
```rust
func toText(p: Principal) : Text
```
Converts Principal into the Principal Id string.

### isEmptyIdentity
___
```rust
func isEmptyIdentity(caller: Principal) : Bool
```
Checks if the caller is empty.

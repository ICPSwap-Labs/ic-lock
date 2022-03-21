import List "mo:base/List";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Int8 "mo:base/Int8";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Char "mo:base/Char";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Error "mo:base/Error";

module {
    let MAX_32: Int  = 0x7fffffff;
    let MAX_64: Int  = 0x7fffffffffffffff;
    let MAX_128: Int = 0x7fffffffffffffffffffffffffffffff;
    let MAX_256: Int = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    let MAX_512: Int = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    
    /**
     * Converts x into a array of Int64 by bit number of bits.
     */
    public func toIntArr(x: Int, bit: Nat) : [Int64] {
        assert(x >= 0);
        assert(bit <= 64);
        let _bit: Nat64 = Nat64.fromNat(bit);
        assert((_bit & (_bit - 1)) == 0);

        var _x: Int = x;
        var arr: [Int64] = [];
        while(_x > 0) {
            let remainder: Int64 = Int64.fromInt(_x % 2 ** bit);
            arr := Array.append<Int64>([remainder], arr);
            _x := bitshiftRight(_x, bit);
        };
        return arr;
    };
    private func ternary(e: Bool, x: Int, y: Int) : Int {
        if (e) {
            x;
        } else {
            y;
        }
    };
    private func bitnums(x: Int) : (Nat, Int) {
        if (x < MAX_64) {
            return (64, MAX_64);
        } else if (x < MAX_128) {
            return (128, MAX_128);
        } else if (x < MAX_256) {
            return (256, MAX_256);
        } else {
            return (512, MAX_512);
        }
    };
    private func pre(x: Int, y: Int) : (Int, Int, Nat, Int) {
        var _x = ternary(x >= 0, x, -x);
        var _y = ternary(y >= 0, y, -y);
        let m = Int.max(_x, _y);
        let (bit: Nat, bitnum: Int) = bitnums(m);
        return (ternary(x >= 0, _x, (bitnum - _x) + 1), ternary(y >= 0, _y, (bitnum - _y) + 1), bit, bitnum);
    };
    private func _bit(x: Int, y: Int, fun: (x1: Int32, y1: Int32) -> Int32) : Int {
        let (x1, y1, bit, m) = pre(x, y);
        var _x = x1;
        var _y = y1;
        var result: Int = 0;
        var firstBit: Int32 = 0;
        for (i in Iter.range(0, Nat.sub(bit, 1))) {
            let bitX: Int32 = Int32.fromInt(ternary(_x > 0, _x % 2, ternary(x >= 0, 0 , 1)));
            let bitY: Int32 = Int32.fromInt(ternary(_y > 0, _y % 2, ternary(y >= 0, 0 , 1)));
            let bitR: Int32 = fun(bitX, bitY);
            _x := bitshiftRight(_x, 1);
            _y := bitshiftRight(_y, 1);
            if (i == Nat.sub(bit, 1)) {
                firstBit := bitR;
            } else {
                result := bitshiftLeft(Int32.toInt(bitR), i) + result;
            }
        };
        if (firstBit == 1) {
            result := -(Int.sub(m, Int.add(result, 1)));
        };
        return result;
    };

    /** 
     * The left shift operation, shifts x by y of bits to the left.
     */
    public func bitshiftLeft(x: Int, y: Int) : Int {
        return x * (2 ** y);
    };
    
    /**
     * The right shift operation, shifts x by y of bits to the right.
     */
    public func bitshiftRight(x: Int, y: Int) : Int {
        if (x < 0) {
            let _x = bitnot(x);
            return bitnot(_x / (2 ** y))
        } else {
            return x / (2 ** y);
        };
    };
    public func bitand(x: Int, y: Int): Int {
        if (x < 0 or y < 0) {
            return _bit(x, y, Int32.bitand) - 2;
        } else {
            return _bit(x, y, Int32.bitand);
        };
    };
    public func bitor(x: Int, y: Int): Int {
        if (x < 0 or y < 0) {
            return _bit(x, y, Int32.bitor) - 2;
        } else {
            return _bit(x, y, Int32.bitor);
        };
    };
    public func bitnot(x: Int): Int {
        return -x - 1;
    };
}
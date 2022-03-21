import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Prim "mo:⛔";
import BitwiseInt "./BitwiseInt";
import BitwiseNat "./BitwiseNat";

module {

    /**
     * Converts the Nat type of x into Int.
     */
    public func toInt(x: Nat) : Int {
        var natArr: [Nat32] = BitwiseNat.toNatArr(x, 8);
        var intVal: Int = 0;
        for (t: Nat32 in natArr.vals()) {
            intVal := BitwiseInt.bitshiftLeft(intVal, 8) + Int32.toInt(Int32.fromNat32(t));
        };
        return intVal;
    };

    /**
     * Converts nat of Nat32 into an array of Nat8.
     */
    public func nat32ToNat8Arr(nat: Nat32) : [Nat8] {
        return [
            Nat8.fromNat(Nat32.toNat((nat >> 24) & 0xFF)), 
            Nat8.fromNat(Nat32.toNat((nat >> 16) & 0xFF)), 
            Nat8.fromNat(Nat32.toNat((nat >> 8) & 0xFF)), 
            Nat8.fromNat(Nat32.toNat((nat) & 0xFF))
        ];
    };

    /**
     * Compares x and y. If x greater than y, return 1, otherwise return 0.
     */
    public func gt(x: Nat, y: Nat) : Nat {
        var r = 0;
        if (x > y) {
            r := 1
        };
        r;
    };
  
    /**
     * Compares x and y. If x lower than y, return 1, otherwise return 0.
     */
    public func lt(x: Nat, y: Nat) : Nat {
        var r = 0;
        if (x < y) {
            r := 1;
        };
        r;
    };

    /** 
     * Checks if the v is zero.
     */
    public func isZero(v: Nat) : Bool {
        Nat.equal(v, 0);
    };

};
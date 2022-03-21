import List "mo:base/List";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Char "mo:base/Char";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import BitwiseNat "./BitwiseNat";
import BitwiseInt "./BitwiseInt";

module {

    public let Nat256Max = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    /**
     * Converts the Int type of x into Nat.
     */
    public func toNat(x: Int) : Nat {
        if (x < 0){
            return Nat.sub(Nat256Max, toNat(Int.neq(x)));
        };
        var intArr: [Int64] = BitwiseInt.toIntArr(x, 8);
        var natVal: Nat = 0;
        for (t: Int64 in intArr.vals()) {
            natVal := BitwiseNat.bitshiftLeft(natVal, 8) + Nat64.toNat(Int64.toNat64(t));
        };
        return natVal;
    };
};
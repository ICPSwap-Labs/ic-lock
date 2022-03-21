import Principal "mo:base/Principal";
import SHA224 "mo:sha224/SHA224";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Prim "mo:⛔";
import CRC32 "./CRC32";
import NatUtils "./NatUtils";

module {
    private let symbols = [
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
    ];

    private let base : Nat8 = 0x10;
  
    /**
     * Encodes an array of Nat8 by Base64, return the encoded string.
     */
    public func encode(array: [Nat8]) : Text {
        Array.foldLeft<Nat8, Text>(array, "", func (accum, u8) {
            accum # fromNat8(u8);
        });
    };
    
    /**
     * Converts an Int number into string.
     */
    public func fromInt(v: Int) : Text {
        return Int.toText(v);
    };

    /**
     * Converts an Nat number into string.
     */
    public func fromNat(v: Nat) : Text {
        return Nat.toText(v);
    };

    /**
     * Converts an Nat8 number into string.
     */
    public func fromNat8(u8: Nat8) : Text {
        let c1 = symbols[Nat8.toNat((u8/base))];
        let c2 = symbols[Nat8.toNat((u8%base))];
        return Char.toText(c1) # Char.toText(c2);
    };
  
    /**
     * Converts a string into Int number.
     */
    public func toInt(txt: Text) : Int {
        assert(txt.size() > 0);
        let chars = txt.chars();
        var num: Nat = 0;
        var negativeFlag: Bool = false;
        for (v in chars) {
            if (Char.toText(v) == "-"){
                negativeFlag := true;
            } else {
                if (Char.toNat32(v) >= 48 and Char.toNat32(v) <= 57) {
                    let charToNum = Nat32.toNat(Char.toNat32(v) - 48);
                    assert(charToNum >= 0 and charToNum <= 9);
                    num := num * 10 + charToNum; 
                } 
            }
        };
        var intNum = NatUtils.toInt(num);
        if(negativeFlag){
            intNum := 0 - intNum;
        };
        return intNum;
    };

    /**
     * Converts a string into Nat number.
     */
    public func toNat(text: Text) : Nat {
        assert(text.size() > 0);
        let chars = text.chars();
        var num: Nat = 0;
        for (v in chars) {
            if (Char.toNat32(v) >= 48 and Char.toNat32(v) <= 57) {
                let charToNum = Nat32.toNat(Char.toNat32(v) - 48);
                assert(charToNum >= 0 and charToNum <= 9);
                num := num * 10 + charToNum; 
            }
        };
        num;
    };

    /**
     * Return the calling string value converted to uppercase.
     */
    public func toUpperCase(text: Text) : Text {
        // FIXME 0 function implemention.
        return text;
    };

    /** 
     * Compares two strings without case sensitive.
     */
    public func equalsIgnoreCase(t1: Text, t2: Text) : Bool {
        return Text.equal(toUpperCase(t1), toUpperCase(t2));
    };

    /**
     * Returns the part of the string t between the start i and end j indexes.
     */
    public func extractText(t: Text, i: Nat, j: Nat) : Text {
        let size = t.size();
        if (i == 0 and j == size) return t;
        assert (j <= size);
        let cs = t.chars();
        var r = "";
        var n = i;
        while (n > 0) {
            ignore cs.next();
            n -= 1;
        };
        n := j;
        while (n > 0) {
            switch (cs.next()) {
                case null { assert false };
                case (?c) { r #= Prim.charToText(c) }
            };
            n -= 1;
        };
        return r;
    };

    /**
     * Divides a string t into each character of the string, puts these characters into an array, and returns the array.
     */
    public func toArray(t: Text) : [Text] {
        var l = Iter.toArray<Char>(Text.toIter(t));
        return Array.map<Char, Text>(l, func (c:Char) : Text {
            return Text.fromChar(c)
        })
    };

    /**
     * Returns a new string by concatenating all of the elements in an array.
     */
    public func fromArray(array: [Text]) : Text {
        var result: Text = "";
        for (value in array.vals()) {
            result := result # value;
        };
        return result;
    };

    public type DirectionType = {
        #start;
        #end;
    };

    public func completionZero(_t: Text, d: DirectionType, n: Nat) : Text {
        var t = _t;
        if (_t.size() >= n) {
            return _t;
        };
        while(t.size() < n){
            if (d == #start){
                t := "0" # t;
            } else if (d == #end){
                t := t # "0";
            }
        };
        return t;
    };

    /**
     * Converts a Nat32 number into a binary string.
     */
    public func binaryToDecimal(_num: Nat32) : Text {
        var str: Text = "";
        var num: Nat32 = _num;
        while(num != 0){
            str := Nat32.toText(Nat32.rem(num, 2)) # str;
            num := Nat32.div(num, 2);
        };
        if (str.size() < 8){
            str := completionZero(str, #start, 8);
        };
        return str;
    };

    /** 
     * Converts a scale-ary string into a Nat number.
     */
    public func scaleToDecimal(number: Text, scale: Nat) : Nat {
        var total: Nat = 0;
        var ch: [Text] = toArray(number);
        var chLength: Nat = ch.size();
        var i = 0;
        while(i < chLength) {
            total := total + toNat(ch[i]) * Nat.pow(scale, chLength - 1 - i);
            i := i + 1;
        };
        return total;
    };

    /**
     * Converts a Hex string into a Nat number.
     */
    public func hexToNumber(_t: Text) : Nat {
        var Hex = toArray(_t);
        var i = 0;
        var Dec = 0;
        var t = 0;
        while (i < Hex.size()){
            switch (Hex[i]){
                case "0" { t := 0 };
                case "1" { t := 1 };
                case "2" { t := 2 };
                case "3" { t := 3 };
                case "4" { t := 4 };
                case "5" { t := 5 };
                case "6" { t := 6 };
                case "7" { t := 7 };
                case "8" { t := 8 };
                case "9" { t := 9 };
                case "a" { t :=10 };
                case "b" { t := 11 };
                case "c" { t := 12 };
                case "d" { t := 13 };
                case "e" { t := 14 };
                case "f" { t := 15 };
                case _ { t := 0 };
            };
            Dec := Dec + t * Nat.pow(16, Hex.size() - i - 1);
            i := i + 1;
        };
        return Dec;
    };
}
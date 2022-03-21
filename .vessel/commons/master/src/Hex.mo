import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Char "mo:base/Char";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Prim "mo:prim";
import Error "mo:base/Error";
import Result "mo:base/Result";
module {

    private type Result<Ok, Err> = Result.Result<Ok, Err>;

    /**
     * Define a type to indicate that the decoder has failed.
     */
    public type DecodeError = {
        #msg : Text;
    };

    private let base : Nat8 = 0x10;

    private let symbols = [
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
    ];

    /**
    * Encodes an array of Nat8 by Hex, and return the encoded array.
    */
    public func encode(array: [Nat8]) : Text {
        Array.foldLeft<Nat8, Text>(array, "", func (accum, w8) {
            accum # encodeW8(w8);
        });
    };

    /**
     * Encodes string by Hex, and return the encoded string.
     */
    public func toHex(_data: Text) : Text {
        var data: [Char] = Iter.toArray(Text.toIter(_data));
        if (data.size() == 0) return "";
        var _t: [Nat8] = Array.map<Char, Nat8>(data, func(c: Char) : Nat8{
            Nat8.fromNat(Nat32.toNat(Char.toNat32(c)));
        });
        return encode(_t);
    };
    /**
    * Encode an unsigned 8-bit integer in hexadecimal format.
    */
    private func encodeW8(w8: Nat8) : Text {
        let c1 = symbols[Prim.nat8ToNat(w8 / base)];
        let c2 = symbols[Prim.nat8ToNat(w8 % base)];
        Prim.charToText(c1) # Prim.charToText(c2);
    };

    /**
    * Decodes string by Hex, and return the decoded Nat8 array.
    */
    public func decode(text: Text) : async [Nat8] {
        let next = text.chars().next;
        func parse() : Result<Nat8, DecodeError> {
            Option.get<Result<Nat8, DecodeError>>(
                Option.chain<Char, Result<Nat8, DecodeError>>(next(), func (c1) {
                    Option.chain<Char, Result<Nat8, DecodeError>>(next(), func (c2) {?
                        Result.chain<Nat8, Nat8, DecodeError>(decodeW4(c1), func (x1) {
                            Result.chain<Nat8, Nat8, DecodeError>(decodeW4(c2), func (x2) {
                                #ok(x1 * base + x2);
                            });
                        });
                    });
                }),
                #err(#msg "Not enough input!"),
            );
        };
        var i = 0;
        let n = text.size() / 2 + text.size() % 2;
        let array = Array.init<Nat8>(n, 0);
        while (i != n) {
            switch (parse()) {
                case (#ok w8) {
                    array[i] := w8;
                    i += 1;
                };
                case (#err err) {
                    switch (err) {
                        case (#msg message) {
                            throw Error.reject(message);
                        };
                    };
                };
            };
        };
        Array.freeze<Nat8>(array);
    };

    /**
    * Decode an unsigned 4-bit integer in hexadecimal format.
    */
    private func decodeW4(char: Char) : Result<Nat8, DecodeError> {
        for (i in Iter.range(0, 15)) {
            if (symbols[i] == char) {
                return #ok(Prim.natToNat8(i));
            };
        };
        let errMsg: Text = "Unexpected character: " # Prim.charToText(char);
        #err(#msg errMsg);
    };
};
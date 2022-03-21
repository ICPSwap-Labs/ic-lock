import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";


module {
    
    /// Returns the bitwise shift left of x by y, x << y.
    public func bitshiftLeft(x: Nat, y: Nat) : Nat {
        return x * (2 ** y);
    };

    ///Returns the bitwise shift right of x by y, x >> y.
    public func bitshiftRight(x: Nat, y: Nat) : Nat {
        return x / (2 ** y);
    };

    public func toNatArr(x: Nat, bit: Nat) : [Nat32] {
        assert(bit <= 32);
        let _bit: Nat32 = Nat32.fromNat(bit);
        assert((_bit & (_bit - 1)) == 0);
        var _x: Nat = x;
        var arr: [Nat32] = [];
        while(_x > 0) {
            let remainder: Nat32 = Nat32.fromNat(_x % (2 ** bit));
            arr := Array.append<Nat32>([remainder], arr);
            _x := bitshiftRight(_x, bit);
        };
        return arr;
    };
    
    private func _bit(x: Nat, y: Nat, fun: (x1: Nat32, y1: Nat32) -> Nat32, bit: Nat) : Nat {
        var _x: Nat = Nat.max(x, y);
        var _y: Nat = Nat.min(x, y);
        var result: Nat = 0;
        var index: Nat = 0;
        while(_x > 0) {
            let bitX: Nat32 = Nat32.fromNat(_x % (2 ** bit));
            let bitY: Nat32 = Nat32.fromNat(_y % (2 ** bit));
            let bitR: Nat32 = fun(bitX, bitY);
            
            _x := bitshiftRight(_x, bit);
            _y := bitshiftRight(_y, bit);
            result := bitshiftLeft(Nat32.toNat(bitR), index) + result;

            index := index + bit;
        };

        return result;
    };

    public func bitor(x: Nat, y: Nat) : Nat {
        return _bit(x, y, Nat32.bitor, 32);
    };
    
    public func bitand(x: Nat, y: Nat) : Nat {
        return _bit(x, y, Nat32.bitand, 32);
    };
    public func bitxor(x: Nat, y: Nat) : Nat {
        return _bit(x, y, Nat32.bitxor, 32);
    };
    
    public func bitnot(x: Nat) : Nat {
        var _x: Nat = x;
        var result: Nat = 0;
        var index: Nat = 0;
        while(_x > 0) {
            let bitX: Nat32 = Nat32.fromNat(_x % (2 ** 32));
            let bitR: Nat32 = Nat32.bitnot(bitX, 0);
            _x := bitshiftRight(_x, 32);
            result := bitshiftLeft(Nat32.toNat(bitR), 32) + result;
            index := index + 32;
        };

        return result;
    };
    public func bitnotWithBit(x: Nat, y: Nat) : Nat {
        assert((y % 32) == 0);    // y has to be a multiple of 32.
        var r = y / 32;
        var _x: Nat = x;
        var result: Nat = 0;
        var index: Nat = 0;
        while (index < r) {
            let bitX: Nat32 = Nat32.fromNat(_x % (2 ** 32));
            let bitR: Nat32 = Nat32.bitnot(bitX, 0);
            _x := bitshiftRight(_x, 32);
            result := bitshiftLeft(Nat32.toNat(bitR), 32 * index) + result;
            index := index + 1;
        };
        return result;
    };
}
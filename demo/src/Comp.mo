import Nat "mo:base/Nat";

actor Comp {

    public shared func add(n: Nat): async Nat {
        n + 1
    };

}
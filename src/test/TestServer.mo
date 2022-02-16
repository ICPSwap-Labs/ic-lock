import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Time "mo:base/Time";

actor {

    public shared(msg) func testCall() :async Bool {
        return true;
    };

}
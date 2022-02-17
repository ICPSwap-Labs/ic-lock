import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Lock "../lock/Lock";
import TestServer "canister:TestServer";

actor {

    private stable var lockNumber :Nat = 0;
    private stable var unlockNumber :Nat = 0;

    public shared(msg) func testLock() :async Nat {
        try {
            await Lock.lock("lockNumber");

            var temp = lockNumber + 1;
            ignore await TestServer.testCall();
            lockNumber := temp;

            await Lock.unlock("lockNumber");
        } catch (e) {
            await Lock.unlock("lockNumber");
        };
        return lockNumber;
    };

    public shared(msg) func testWithoutLock() :async Nat {
        var temp = unlockNumber + 1;
        ignore await TestServer.testCall();
        unlockNumber := temp;

        return unlockNumber;
    };

    public query func getLockNumber() :async Nat {
        return lockNumber;
    };

    public query func getUnlockNumber() :async Nat {
        return unlockNumber;
    };
}
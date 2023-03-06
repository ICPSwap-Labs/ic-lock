import Nat "mo:base/Nat";

actor class Next(lockId: Text, compId: Text) {
    private var num: Nat = 0;
    private type Lock = actor {
        lock: shared (key: Text, expires: Int, retry: Nat) -> async Nat;
        unlock: shared (key: Text, index: Nat) -> async ();
    };
    private type Comp = actor {
        add: shared (n: Nat) -> async Nat;
    };
    private var lock: Lock = actor (lockId);
    private var comp: Comp = actor (compId);
    public shared func nextId(): async Nat {
        num := await comp.add(num);
        num
    };
    public shared func nextIdWithLock(): async Nat {
        var index = await lock.lock("id", 3000, 3000);
        num := await comp.add(num);
        await lock.unlock("id", index);
        num
    }

}
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Error "mo:base/Error";

shared({ caller }) actor class Lock() { 

    public type Role = {
        #RoleOwner;
        #RoleAdmin;
        #RoleClient;
        #RoleAnyone;
    };
    public type LockEntry = {
        owner: Principal;
        index: Nat;
        lockedAt: Time.Time;
        expireAt: Time.Time;
    };
    public type LockMsg = {
        #addAdmin : () -> Principal;
        #addClient : () -> Principal;
        #allLocks : () -> ();
        #getAccessControlState : () -> ();
        #lock : () -> (Text, Int, Int);
        #setAdmins : () -> [Principal];
        #setClients : () -> [Principal];
        #unlock : () -> (Text, Nat);
        #clearExpired: () -> ();
        #deleteLock: () -> (Text);
    };

    private stable var _owners: [Principal] = [caller];
    private stable var _admins: [Principal] = [];
    private stable var _clients: [Principal] = [];
    private stable var _index: Nat = 1;

    private stable var mapEntries: [(Text,LockEntry)] = [];
    private var map: HashMap.HashMap<Text, LockEntry> = HashMap.HashMap<Text, LockEntry>(16, Text.equal, Text.hash);  
    private func requireRole(msg: LockMsg) : Role {
        switch (msg) {
            case (#addAdmin args) { #RoleOwner };
            case (#setAdmins args) { #RoleOwner };
            case (#addClient args) { #RoleAdmin };
            case (#setClients args) { #RoleAdmin };
            case (#clearExpired _) { #RoleAdmin };
            case (#deleteLock args) { #RoleAdmin };
            case (_) { #RoleClient };
        };
    };

    private func _contants(principal: Principal, arr: [Principal]) : Bool {
        for (p in arr.vals()) {
            if (Principal.equal(principal, p)) {
                return true;
            };
        };
        return false;
    };
    
    private func _add(arr: [Principal], item: Principal) : [Principal] {
        var buffer: Buffer.Buffer<Principal> = Buffer.Buffer<Principal>(arr.size() + 1);
        var exists: Bool = false;
        for (c in arr.vals()) {
            if (Principal.equal(c, item)) {
                exists := true;
            };
            buffer.add(c);
        };
        if (not exists) {
            buffer.add(item);
        };
        return buffer.toArray();
    };

    
    private func _sleep(i: Nat): async () {
        var countDown : Nat = 0;
        while (countDown < i) {
            countDown := countDown + 1;
        };
    };
    private func _setNx(key: Text, owner: Principal, now: Time.Time, expireAt: Time.Time, index: Nat): Bool {
        switch (map.get(key)) {
            case (?v) {
                if (now < v.expireAt) {
                    return false;
                };
            };
            case (_) {
            };
        };
        map.put(key, { owner = owner; lockedAt = now; expireAt = expireAt; index = index; });
        return true;
    };
    
    public shared(msg) func lock(key: Text, expires: Int, timeout: Int): async Nat {
        var count: Nat = 0;
        var start: Time.Time = Time.now();
        var timeoutAt: Time.Time = start + timeout * 1000000;
        var now = start;
        while (now < timeoutAt) {
            let index = _index;
            var r = _setNx(key, msg.caller, now, now + expires * 1000000, index);
            if (r) {
                _index := _index + 1;
                return index;
            };
            await _sleep(1000);
            count := count + 1;
            now := Time.now();
        };
        return 0;
    };
    
    public shared(msg) func unlock(key: Text, index: Nat): async () {
        switch(map.get(key)) {
            case(?v) {
                var now: Time.Time = Time.now();
                if ((Principal.equal(msg.caller, v.owner) and Nat.equal(v.index, index)) or (now >= v.expireAt)) {
                    map.delete(key);
                } else {
                    throw Error.reject("PermissionDenied: index=" # Nat.toText(index));
                }
            };
            case(_) { };
        };
    };
    
    public shared(msg) func deleteLock(key: Text): async () {
        switch(map.get(key)) {
            case(?v) {
                map.delete(key);
            };
            case(_) { };
        };
    };
    public shared(msg) func allLocks(): async [(Text, LockEntry)] {
        return Iter.toArray(map.entries());
    };
    public shared(msg) func clearExpired(): async () {
        var now: Time.Time = Time.now();
        map := HashMap.mapFilter<Text, LockEntry, LockEntry>(map, Text.equal, Text.hash, func (k, v) = if (now < v.expireAt) { ?v } else { null });
    };
    public shared func setClients(clients: [Principal]): async () {
        _clients := clients;
    };
    public shared func addClient(client: Principal): async () {
        _clients := _add(_clients, client);
    };
    public shared func setAdmins(admins: [Principal]): async () {
        _admins := admins;
    };
    public shared(msg) func addAdmin(admin: Principal): async () {
        _admins := _add(_admins, admin);
    };
    public query func getAccessControlState() : async { owners: [Principal]; admins: [Principal]; clients: [Principal]} {
        return {
            owners = _owners;
            admins = _admins;
            clients = _clients;
        }
    };

    system func preupgrade() {
        mapEntries := Iter.toArray(map.entries());
    };

    system func postupgrade() {
        mapEntries := []; 
    };
    system func inspect({
        arg : Blob;
        caller : Principal;
        msg : LockMsg;
    }) : Bool {
        switch(requireRole(msg)) {
            case (#RoleOwner) {
                if (_contants(caller, _owners)) {
                    return true;
                };
                return false;
            };
            case (#RoleAdmin) {
                if (_contants(caller, _admins) or _contants(caller, _owners)) {
                    return true;
                };
                return false;
            };
            case (#RoleClient) {
                if (_contants(caller, _clients) or _contants(caller, _owners)) {
                    return true;
                };
                return false;
            };
            case (#RoleAnyone) {
                return true;
            };
        };
    };
};

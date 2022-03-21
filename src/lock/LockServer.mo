import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import PrincipalUtils "mo:commons/PrincipalUtils";
import CollectUtils "mo:commons/CollectUtils";

actor {

    private stable var mapEntries: [(Text, Bool)] = [];
    private var map: HashMap.HashMap<Text, Bool> = HashMap.HashMap<Text, Bool>(16, Text.equal, Text.hash);

    private stable var adminList: [Text] = [];

    private stable var clientList: [Text] = [];

    public shared(msg) func lock(key: Text): async { state: Bool; time: Int; } {
        principalToAddressAndAssertPermission(msg.caller);

        switch(map.get(key)) {
            case(?v) {
                if(v) {
                    return { state = false; time = Time.now(); }
                } else {
                    map.put(key, true);
                    return { state = true; time = Time.now(); }
                };
            };
            case(_) {
                map.put(key, true);
                return { state = true; time = Time.now(); }
            };
        }
    };
    
    public shared(msg) func unlock(key: Text): async () {
        principalToAddressAndAssertPermission(msg.caller);

        map.delete(key);
    };

    public query(msg) func getLockState(key: Text): async Bool {
        switch(map.get(key)) {
            case(?v) { return v; };
            case(_) { return false; };
        }
    };

    public query(msg) func getAllLocks(): async [Text] {
        var all : List.List<Text> = List.nil();
        for((key, exists) in map.entries()){
            all := List.push(key, all);
        };
        List.toArray(all);
    };

    public query(msg) func getAdminList(): async [Text] {
        principalToAddressAndAssertPermission(msg.caller);
        return adminList;
    };

    public query(msg) func getClientList(): async [Text] {
        principalToAddressAndAssertPermission(msg.caller);
        return clientList;
    };

    public shared(msg) func addAdmin(admin: Text): async Bool {
        principalToAddressAndAssertPermission(msg.caller);
        var adminAddress = PrincipalUtils.toAddress(Principal.fromText(admin));
        if (not CollectUtils.arrayContains<Text>(adminList, adminAddress, Text.equal)) {
            var adminListTemp: List.List<Text> = List.fromArray(adminList);
            adminListTemp := List.push(adminAddress, adminListTemp);
            adminList := List.toArray(adminListTemp);
        };
        return true;
    };

    public shared(msg) func removeAdmin(admin: Text): async Bool {
        principalToAddressAndAssertPermission(msg.caller);
        adminList := CollectUtils.arrayRemove<Text>(adminList, admin, Text.equal);
        return true;
    };

    public shared(msg) func addClient(client: Text): async Bool {
        principalToAddressAndAssertPermission(msg.caller);
        var clientAddress = PrincipalUtils.toAddress(Principal.fromText(client));
        if (not CollectUtils.arrayContains<Text>(clientList, clientAddress, Text.equal)) {
            var clientListTemp: List.List<Text> = List.fromArray(adminList);
            clientListTemp := List.push(clientAddress, clientListTemp);
            clientList := List.toArray(clientListTemp);
        };
        return true;
    };

    public shared(msg) func removeClient(client: Text): async Bool {
        principalToAddressAndAssertPermission(msg.caller);
        clientList := CollectUtils.arrayRemove<Text>(clientList, client, Text.equal);
        return true;
    };

    private func principalToAddressAndAssertPermission(caller: Principal): () {
        let _caller = PrincipalUtils.toAddress(caller);
        if(adminList.size() == 0 and clientList.size() == 0){
            return;
        } else{
            assert(CollectUtils.arrayContains<Text>(adminList, _caller, Text.equal) or CollectUtils.arrayContains<Text>(clientList, _caller, Text.equal));
        };
    };

    system func preupgrade() {
        mapEntries := Iter.toArray(map.entries());
    };

    system func postupgrade() {
        mapEntries := []; 
    };
}
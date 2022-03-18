import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import List "mo:base/List";
import Time "mo:base/Time";

actor {

    private var map: HashMap.HashMap<Text, Bool> = HashMap.HashMap<Text, Bool>(16, Text.equal, Text.hash);

    public shared(msg) func lock(key: Text): async { state: Bool; time: Int; } {
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
        map.delete(key);
    };

    public shared(msg) func getLockState(key: Text): async Bool {
        switch(map.get(key)) {
            case(?v) { return v; };
            case(_) { return false; };
        }
    };

}
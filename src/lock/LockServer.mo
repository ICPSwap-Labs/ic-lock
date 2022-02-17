import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import List "mo:base/List";
import Time "mo:base/Time";

actor {

    private var map: HashMap.HashMap<Text, Bool> = HashMap.HashMap<Text, Bool>(16, Text.equal, Text.hash);

    public shared(msg) func setNx(key: Text): async { status: Bool; time: Int; } {
        switch(map.get(key)) {
            case(?v) {
                if(v) {
                    return { status = false; time = Time.now(); }
                } else {
                    map.put(key, true);
                    return { status = true; time = Time.now(); }
                };
            };
            case(_) {
                map.put(key, true);
                return { status = true; time = Time.now(); }
            };
        }
    };
    
    public shared(msg) func del(key: Text): async () {
        map.delete(key);
    };

    public shared(msg) func get(key: Text): async Bool {
        switch(map.get(key)) {
            case(?v) { return v; };
            case(_) { return false; };
        }
    };

}
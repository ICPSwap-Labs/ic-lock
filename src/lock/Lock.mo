import Text "mo:base/Text";
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Time "mo:base/Time";
import LockServer "canister:LockServer";

module {

    public func lock(key: Text): async () {
        Debug.print("" # key # " lock");
        var startTime = Time.now();

        label lockW while(true) {
            var lockR = await LockServer.lock(key);
            if(lockR.state) { break lockW; };
            if((3000000000 + startTime) <= lockR.time) { throw Error.reject("" # key # " lock time out"); };

            var internalWhileTimes = 0;
            while(internalWhileTimes < 1000){
                internalWhileTimes := internalWhileTimes + 1;
            };
        };
    };

    public func lockImmediately(key: Text): async Bool {
        var lockR = await LockServer.lock(key);
        var lockState :Bool = lockR.state;
        Debug.print("" # key # " lock state is " # debug_show(lockState));
        return lockState;
    };
    
    public func unlock(key: Text): async () {
        Debug.print("" # key # " unlock");
        await LockServer.unlock(key);
    };

    public func isLocked(key: Text): async Bool {
        var lockState :Bool = await LockServer.getLockState(key);
        Debug.print("" # key # " lock state is " # debug_show(lockState));
        return lockState;
    };
}

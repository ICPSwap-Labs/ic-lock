# ic-lock

  - [Introduction](#Introduction)
  - [Library](#Library)

## Introduction
IC Lock, a mutual exclusion lock ensures the integrity of shared data operations through flexible and customizable locking granularity.

When we operate on a shared resource in a function, if the async function itself (the callee) does not use await, then it is atomic. If it uses await, it is only atomic between awaits.

Let's create a couter canister (Test.mo). We’d get in trouble if we did something like:

```motoko
public shared(msg) func testWithoutLock() :async Nat {
    var temp = unlockNumber + 1;
    ignore await TestServer.testCall();
    unlockNumber := temp;
    return unlockNumber;
};
``` 
In the test case of this project, we execute five calls concurrently, and the result is as follows:
```bash
$ sh test.sh testWithoutLock
(1 : nat)
(1 : nat)
(1 : nat)
(1 : nat)
(1 : nat)
```
As we can see, it can not guarantee that anyone gets the processed number.

But the situation can be improved, if we do like this:
```motoko
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
```
Execute the same test flow, the result is as follows:
```bash
$ sh test.sh testLock
(3 : nat)
(1 : nat)
(2 : nat)
(4 : nat)
(5 : nat)
```
So that we can use ic-lock to make requests execute serially, avoid reading dirty data and ensure atomicity when calling a canister function.

## Library

### LockServer

#### lock
___
```motoko
func lock(key: Text): async { state: Bool; time: Int; }
``` 
Lock a resource with key. Return a state and current time.

#### unlock
___
```motoko
func unlock(key: Text): async ()
```
Unlock a resource with key.

#### getLockState
___
```motoko
func getLockState(key: Text): async Bool
```
Get the lock state with key.

### Lock

#### lock
___
```motoko
func lock(key: Text): async ()
```
Lock the resource and wait if the lock is unsuccessful. Throws a timeout exception if the wait exceeds 30 seconds.

#### lockImmediately
___
```motoko
func lockImmediately(key: Text): async Bool
```
Lock the resource, return false if the lock is unsuccessful.

#### unlock
___
```motoko
func unlock(key: Text): async ()
```
Unlock the resource with key.

#### isLocked
___
```motoko
func isLocked(key: Text): async Bool
```
Check the lock state with key.

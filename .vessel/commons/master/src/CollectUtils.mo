import Principal "mo:base/Principal";
import SHA224 "mo:sha224/SHA224";
import Nat8 "mo:base/Nat8";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import CRC32 "./CRC32";
import Char "mo:base/Char";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Prim "mo:⛔";

module {
  
    /**
     * Determines whether an array matchs a certain value among its entries, returning true or false as "equal" function returns.
     */
    public func arrayContains<T>(arr: [T], item: T, equal: (T, T) -> Bool) : Bool {
        for (t: T in arr.vals()) {
            if (equal(t, item)) {
                return true;
            };
        };
        return false;
    };
    
    public func listContains<T>(list: List.List<T>, item: T, equal: (T, T) -> Bool) : Bool {
        var size = List.size<T>(list);
        var result = false;
        func f(t: T): Bool {
            return equal(item, t);
        };
        if (size > 0) {
            switch(List.find<T>(list, f)) {
                case (?o) {
                    return true;
                };
                case (_) {
                    return false;
                };
            };
        };
        return false;
    };


    /** 
     * Removes matched item in the list, returning the list which removed item.
     */
    public func listRemove<T>(list: List.List<T>, item: T, equal: (T, T) -> Bool) : List.List<T> {
        var newList: List.List<T> = List.nil<T>();
        var size = List.size<T>(list);
        if (size > 0) {
            List.iterate<T>(
                list,
                func (t: T) : () {
                    if (not equal(t, item)) {
                        newList := List.push<T>(t, newList);
                    };
                }
            );
        };
        return newList;
    };

    /**
     * Removes matched element in the array, returning the array which removed element.
     */
    public func arrayRemove<T>(arr: [T], item: T, equal: (T, T) -> Bool) : [T] {
        var newArray : [T] = [];
        for (t : T in arr.vals()) {
            if (not equal(t, item)) {
                newArray := Array.append<T>(newArray, [t]);
            };
        };
        return newArray;
    };

    /**
     * Returns a portion of the list, starting at the offset index and extending for a given number of items afterwards.
     */
    public func listRange<T>(list: List.List<T>, offset: Nat, limit: Nat) : List.List<T> {
        let size = List.size<T>(list);
        if (offset >= 0 and size > offset) {
            if (offset == 0) {
                return List.take<T>(list, limit);
            } else {
                let (l1, l2) = List.split<T>(offset, list);
                return List.take<T>(l2, limit);
            };
        };
        return List.nil<T>(); 
    };

    /** 
     * Returns a portion of the array, starting at the offset index and extending for a given number of elements afterwards.
     */
    public func arrayRange<T>(arr: [T], offset: Nat, limit: Nat) : [T] {
        let size: Nat = arr.size();
        var end: Nat = offset + limit - 1;
        if (end > Nat.sub(size, 1)) {
            end := size - 1;
        };
        var result: [T] = [];
        if (offset >= 0 and size > offset) {
            for (i in Iter.range(offset, end)) {
                result := Array.append(result, [arr[i]]);
            };
        };
        return result;
    };
 
    /**
     * Sorts the elements of an array and returns the sorted array. The sort order is determined by cmp function.
     */
    public func sort<A>(xs : [A], cmp : (A, A) -> Order.Order) : [A] {
        let tmp : [var A] = Array.thaw(xs);
        sortInPlace(tmp, cmp);
        Array.freeze(tmp)
    };

    /**
     * Sorts the elements of an array in place and returns the sorted array. The sort order is determined by cmp function.
     */
    public func sortInPlace<A>(xs : [var A], cmp : (A, A) -> Order.Order) {
        if (xs.size() < 2) return;
        let aux : [var A] = Array.tabulateVar<A>(xs.size(), func i { xs[i] });

        func merge(lo : Nat, mid : Nat, hi : Nat) {
            var i = lo;
            var j = mid + 1;
            var k = lo;
            while(k <= hi) {
                aux[k] := xs[k];
                k += 1;
            };
            k := lo;
            while(k <= hi) {
                if (i > mid) {
                    xs[k] := aux[j];
                    j += 1;
                } else if (j > hi) {
                    xs[k] := aux[i];
                    i += 1;
                } else if (Order.isLess(cmp(aux[j], aux[i]))) {
                    xs[k] := aux[j];
                    j += 1;
                } else {
                    xs[k] := aux[i];
                    i += 1;
                };
                k += 1;
            };
        };

        func go(lo : Nat, hi : Nat) {
            if (hi <= lo) return;
            let mid : Nat = lo + (hi - lo) / 2;
            go(lo, mid);
            go(mid + 1, hi);
            merge(lo, mid, hi);
        };
        go(0, xs.size() - 1);
    };
}
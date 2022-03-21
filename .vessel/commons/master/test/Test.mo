import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Base64 "../src/Base64";
import CollectUtils "../src/CollectUtils";
import TextUtils "../src/TextUtils";
import PrincipalUtils "../src/PrincipalUtils";

actor Test {

    type Obj = {
        f1: Text;
        f2: Nat;
    };

    public func testBase64(): async () {
        assert(Base64.encode("Test Base64 encode!") == "VGVzdCBCYXNlNjQgZW5jb2RlIQ==");
        assert(Base64.encode("Test Base64 encode1!") == "VGVzdCBCYXNlNjQgZW5jb2RlMSE=");
    };
    public func testCollectUtils(): async () {
        var arr1: [Text] = ["a", "b", "c", "d", "e"];
        var arr2: [Obj] = [{f1 = "a"; f2 = 0;}, {f1 = "b"; f2 = 1;}, {f1 = "c"; f2 = 2;}, {f1 = "d"; f2 = 3;}, {f1 = "e"; f2 = 4;}];
        var obj1: Obj = {f1 = "a"; f2 = 0;};
        var obj2: Obj = {f1 = "a"; f2 = 1;};
        var list1: List.List<Text> = List.fromArray<Text>(arr1);
        var list2: List.List<Obj> = List.fromArray<Obj>(arr2);
        func objEqual(a: Obj, b: Obj): Bool {
            return ((a.f1 == b.f1) and (a.f2 == b.f2))
        };

        assert(CollectUtils.arrayContains<Text>(arr1, "a", Text.equal));
        assert(not CollectUtils.arrayContains<Text>(arr1, "f", Text.equal));
        assert(CollectUtils.arrayContains<Obj>(arr2, obj1, objEqual));
        assert(not CollectUtils.arrayContains<Obj>(arr2, obj2, objEqual));

        assert(CollectUtils.listContains<Text>(list1, "a", Text.equal));
        assert(not CollectUtils.listContains<Text>(list1, "f", Text.equal));
        assert(CollectUtils.listContains<Obj>(list2, obj1, objEqual));
        assert(not CollectUtils.listContains<Obj>(list2, obj2, objEqual));


        assert(CollectUtils.arrayRemove<Text>(arr1, "a", Text.equal).size() == (arr1.size() - 1: Nat));
        assert(not CollectUtils.arrayContains<Text>(CollectUtils.arrayRemove<Text>(arr1, "a", Text.equal), "a", Text.equal));

        assert(List.size<Text>(CollectUtils.listRemove<Text>(list1, "a", Text.equal)) == (List.size<Text>(list1) - 1: Nat));  
        assert(List.size<Text>(CollectUtils.listRemove<Text>(list1, "f", Text.equal)) == List.size<Text>(list1));  
        assert(List.size<Obj>(CollectUtils.listRemove<Obj>(list2, obj1, objEqual)) == (List.size<Obj>(list2) - 1: Nat));
        assert(List.size<Obj>(CollectUtils.listRemove<Obj>(list2, obj2, objEqual)) == List.size<Obj>(list2) );

        assert(CollectUtils.arrayRange<Text>(arr1, 1, 1).size() == 1);
        assert(CollectUtils.arrayRange<Text>(arr1, 1, 2).size() == 2);
        assert(CollectUtils.arrayRange<Text>(arr1, 1, 5).size() == 4);
        assert(not CollectUtils.arrayContains<Text>(CollectUtils.arrayRange<Text>(arr1, 1, 1), "a", Text.equal));
        assert(CollectUtils.arrayContains<Text>(CollectUtils.arrayRange<Text>(arr1, 1, 1), "b", Text.equal));
        assert(not CollectUtils.arrayContains<Text>(CollectUtils.arrayRange<Text>(arr1, 1, 1), "c", Text.equal));
        
        assert(CollectUtils.arrayRange<Obj>(arr2, 1, 1).size() == 1);
        assert(CollectUtils.arrayRange<Obj>(arr2, 1, 2).size() == 2);
        assert(CollectUtils.arrayContains<Obj>(CollectUtils.arrayRange<Obj>(arr2, 0, 1), obj1, objEqual));
        assert(not CollectUtils.arrayContains<Obj>(CollectUtils.arrayRange<Obj>(arr2, 1, 1), obj1, objEqual));

        assert(List.size<Text>(CollectUtils.listRange<Text>(list1, 1, 1)) == 1);
        assert(List.size<Text>(CollectUtils.listRange<Text>(list1, 1, 2)) == 2);
        assert(not CollectUtils.listContains<Text>(CollectUtils.listRange<Text>(list1, 1, 1), "a", Text.equal));
        assert(CollectUtils.listContains<Text>(CollectUtils.listRange<Text>(list1, 1, 1), "b", Text.equal));
        assert(not CollectUtils.listContains<Text>(CollectUtils.listRange<Text>(list1, 1, 1), "c", Text.equal));

        assert(List.size<Obj>(CollectUtils.listRange<Obj>(list2, 1, 1)) == 1);
        assert(List.size<Obj>(CollectUtils.listRange<Obj>(list2, 1, 2)) == 2);
        assert(CollectUtils.listContains<Obj>(CollectUtils.listRange<Obj>(list2, 0, 1), obj1, objEqual));
        assert(not CollectUtils.listContains<Obj>(CollectUtils.listRange<Obj>(list2, 1, 1), obj1, objEqual));

    };
    public func testTextUtils(): async () {

        assert(TextUtils.hexToNumber("0") == 0);
        assert(TextUtils.hexToNumber("1") == 1);
        assert(TextUtils.hexToNumber("2") == 2);
        assert(TextUtils.hexToNumber("3") == 3);
        assert(TextUtils.hexToNumber("4") == 4);
        assert(TextUtils.hexToNumber("5") == 5);
        assert(TextUtils.hexToNumber("6") == 6);
        assert(TextUtils.hexToNumber("7") == 7);
        assert(TextUtils.hexToNumber("8") == 8);
        assert(TextUtils.hexToNumber("9") == 9);
        assert(TextUtils.hexToNumber("a") == 10);
        assert(TextUtils.hexToNumber("b") == 11);
        assert(TextUtils.hexToNumber("c") == 12);
        assert(TextUtils.hexToNumber("d") == 13);
        assert(TextUtils.hexToNumber("e") == 14);
        assert(TextUtils.hexToNumber("f") == 15);
    };

    public func testPrincipalUtils(): async () {
        assert(PrincipalUtils.toAddress(Principal.fromText("erojd-joivm-imznh-hxhus-zt4pn-6otr4-vytne-brdpt-xy2oj-qkisx-tae")) == "f5a120a866bc06058c812af20fdd4cfb73c32e51bbb3dc9733e25fd4e0050228");
    };
}
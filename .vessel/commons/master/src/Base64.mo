import Nat "mo:base/Nat";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Nat16 "mo:base/Nat16";
import List "mo:base/List";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";

module Base64 {
    let base64Chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/", "="];
    
    public func encode(_str: Text): Text{
        var output = "";
        var i:Nat = 0;  
        var input:[Nat8] = Blob.toArray(Text.encodeUtf8(_str));  
        var chr1:Nat8 = 0;var chr2:Nat8 = 0;var chr3:Nat8 = 0;var enc1:Nat8 = 0;var enc2:Nat8 = 0;var enc3:Nat8 = 0;var enc4:Nat8 = 0;
        while (i < input.size()) {  
            var chr1 = input[i];
            i := i+1;
            var chr2Out = false;
            if (i >= input.size()) {
                chr2Out := true;
                chr2 := 0;
            } else {
                chr2 := input[i];
            };
            i := i+1;
            var chr3Out = false;
            if (i >= input.size()) {
                chr3Out := true;
                chr3 := 0;
            } else {
                chr3 := input[i]
            };
            i := i+1;
            enc1 := chr1 >> 2;  
            enc2 := ((chr1 & 3) << 4) | (chr2 >> 4);  
            enc3 := ((chr2 & 15) << 2) | (chr3 >> 6); 
            enc4 := chr3 & 63;  
            if (chr2Out) {  
                enc3 := 64;  
                enc4 := 64;
            } else if (chr3Out) {  
                enc4 := 64;
            };
            output := output#base64Chars[Nat8.toNat(enc1)]#base64Chars[Nat8.toNat(enc2)]#base64Chars[Nat8.toNat(enc3)]#base64Chars[Nat8.toNat(enc4)];  
        };
        return output;
    };
}
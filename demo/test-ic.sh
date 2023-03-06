#!/bin/bash
function install() {
    # Please make sure there have enough balance in the wallet.
    dfx canister --network=ic create --all
    dfx build --network=ic
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic install Lock 
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic install Comp
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic install Next --argument="(\"$(dfx canister --network=ic id Lock)\", \"$(dfx canister --network=ic id Comp)\")"
}
function seq_get() {
    for i in {1..5};
    do
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic call Next nextId
    done
}

function curr_get() {
    for i in {1..5};
    do
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic call Next nextId &
    done
}

function curr_get_with_lock() {
    for i in {1..5};
    do
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic call Next nextIdWithLock &
    done
}

function lock() {
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic call Lock lock "(\"$1\", $2, $3)"
}

function unlock() {
    dfx canister --wallet=$(dfx identity --network ic get-wallet) --network=ic call Lock unlock "(\"$1\", $2)"
}

case $1 in
install)
    install
    ;;
curr)
    curr_get
    ;;
withLock)
    curr_get_with_lock
    ;;
lock)
    lock $2 $3 $4
    ;;
unlock)
    unlock $2 $3
    ;;
*)
    seq_get
    ;;
esac
#!/bin/bash
function install() {
    dfx stop
    dfx start --clean --background
    dfx canister create --all
    dfx build
    dfx canister install Lock 
    dfx canister install Comp
    dfx canister install Next --argument="(\"$(dfx canister id Lock)\", \"$(dfx canister id Comp)\")"
}
function seq_get() {
    for i in {1..5};
    do
    dfx canister call Next nextId
    done
}

function curr_get() {
    for i in {1..5};
    do
    dfx canister call Next nextId &
    done
}

function curr_get_with_lock() {
    for i in {1..5};
    do
    dfx canister call Next nextIdWithLock &
    done
}

function lock() {
    dfx canister call Lock lock "(\"$1\", $2, $3)"
}

function unlock() {
    dfx canister call Lock unlock "(\"$1\", $2)"
}

case $1 in
install)
    install
    ;;
seq)
    seq_get
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
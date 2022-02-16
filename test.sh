#!/bin/bash

test_name=$1

test_lock() {
    times=5
    i=1
    while [ $i -le $times ]
        do
            let 'i++'
            dfx canister call Test testLock &
        done
    wait
}

test_without_lock() {
    times=5
    i=1
    while [ $i -le $times ]
        do
            let 'i++'
            dfx canister call Test testWithoutLock &
        done
    wait
}

if [ $test_name = "testLock" ]
then
test_lock

elif [ $test_name = "testWithoutLock" ]
then
test_without_lock

else
  echo "wrong test"
fi
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/*
* Return values 
* Set arguments
* Get values from external calls
* Revert with string
* Logs
* Deploy contracts
* Use keccak256 function

NOTE
----

* No garbage collection
* Memory is arranged in 32 byte sequences
* Only 4 instructions: mload, mstore, mstore8 and msize
*/
contract YulMemory {
    function mstoreExample() public pure {
        assembly {
            mstore(0x0, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            mstore(0x0, 0x0) // reset
            mstore(0x1, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
        }
    }

    function mstore8Example() public pure {
        assembly {
            mstore8(0x0, 0x7)
            mstore(0x0, 0x7)
        }
    }
}
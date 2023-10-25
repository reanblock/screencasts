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

import "hardhat/console.sol";

contract YulMemory {
    uint256[2] arrayInStorage = [10, 11]; // 0xa, 0xb

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

    // function demonstrates how solidity automatically 
    // updates the free memory pointer
    function freeMemoryPointer() public view {
        bytes32 ptrStart;
        bytes32 ptrEnd;

        assembly {
            ptrStart := mload(0x40)
        }

        uint256[2] memory arrayInMemory = arrayInStorage; // 64 bytes
        arrayInMemory[0]; // hides compiler warning

        assembly {
            ptrEnd := mload(0x40)
        }

        logHelper("ptr (start)", ptrStart, "");
        logHelper("ptr (end)", ptrEnd, "");
    }

    // function demonstrates msize
    function memSizeExample() public view {
        bytes32 ptrStart;
        bytes32 ptrMid;
        bytes32 ptrEnd;
        bytes32 _msizeStart;
        bytes32 _msizeMid;
        bytes32 _msizeEnd;

        assembly {
            ptrStart := mload(0x40)
            _msizeStart := msize()
        }

        uint256[2] memory arrayInMemory = arrayInStorage; // 64 bytes
        arrayInMemory[0]; // hides compiler warning

        assembly {
            ptrMid := mload(0x40)
            _msizeMid := msize()
        }

        assembly {
            pop(mload(0xff)) // manually access some data ahead of free mem ptr
            ptrEnd := mload(0x40) // unchanged because solidity is unaway of the pop
            _msizeEnd := msize() // now msize is further away from the free mem ptr
        }

        logHelper("ptr & msize (start)", ptrStart, _msizeStart);
        logHelper("ptr & msize (after copy arrayInStorage to memory (64bytes))", ptrMid, _msizeMid);
        logHelper("ptr & msize (after accessing memory location 0xff)", ptrEnd, _msizeEnd);
    }

    function abiEncode() public pure {
        bytes32 ptrStart;
        bytes32 ptrEnd;

        assembly {
            ptrStart := mload(0x40) // 0x80
        }

        abi.encode(uint256(12), uint128(13)); // 0xc, 0xd

        assembly {
            ptrEnd := mload(0x40)
        }

        logHelper("ptr (start)", ptrStart, "");
        logHelper("ptr (end)", ptrEnd, "");
    }

     function abiEncodePacked() public pure {
        bytes32 ptrStart;
        bytes32 ptrEnd;

        assembly {
            ptrStart := mload(0x40)
        }

        /*
            abi.encodePacked(uint256(14), uint128(15)); // 0xe, 0xf

            0x40 -> 0xd0

            0x80 -> 0x30    (48 bytes length follows...)
            0xa0 -> 0xe     (uint256 14)
            0xc0 -> 0xf     (uint128 15)

            Thats why 0xd0 is the next free space in memory!
        */
        abi.encodePacked(uint256(14), uint128(15)); // 0xe, 0xf

        assembly {
            ptrEnd := mload(0x40)
        }

        logHelper("ptr (start)", ptrStart, "");
        logHelper("ptr (end)", ptrEnd, "");
    }

    function logHelper(string memory message, bytes32 value1, bytes32 value2) internal pure {
        console.log(message);
        console.logBytes(abi.encode(value1));
        console.logBytes(abi.encode(value2));
    }
}
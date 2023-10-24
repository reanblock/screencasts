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
    event FreeMemoryPointerAddress(bytes32 ptr);
    event FreeMemoryPointerAddressMSize(bytes32 ptr, bytes32 _msize);

    struct MemData {
        uint256 n1;
        uint256 n2;
    }

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
    function freeMemoryPointer() public {
        bytes32 ptr;
        assembly {
            ptr := mload(0x40)
        }
        emit FreeMemoryPointerAddress(ptr);
        MemData memory data = MemData({n1: 1, n2: 2});
        data.n1; // hides warning
        assembly {
            ptr := mload(0x40)
        }
        emit FreeMemoryPointerAddress(ptr);
    }

    // function demonstrates msize
    function memSizeExample() public {
        bytes32 ptr;
        bytes32 _msize;
        assembly {
            ptr := mload(0x40)
            _msize := msize()
        }
        emit FreeMemoryPointerAddressMSize(ptr, _msize);

        MemData memory data = MemData({n1: 1, n2: 2});
        data.n1; // hides warning

        assembly {
            ptr := mload(0x40)
            _msize := msize()
        }
        emit FreeMemoryPointerAddressMSize(ptr, _msize);

        assembly {
            pop(mload(0xff))
            ptr := mload(0x40)
            _msize := msize()
        }
        emit FreeMemoryPointerAddressMSize(ptr, _msize);
    }
}
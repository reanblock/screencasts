// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract YulStorage {
    uint256 val = 99; // slot 0
    uint256 val1 = 199; // slot 1
    uint256 val2 = 188; // slot 2
    // begin slot 3
    uint128 public a=9;
    uint96 public b=7;
    uint16 public c=5;
    uint8 public d=3;
    // end slot 3

    function getSlotAndOffset() external pure returns(uint256 slot, uint256 offset) {
        assembly {
            slot := c.slot
            offset := c.offset
        }
    }

    function readSlot3VarC() external view returns (uint256 cval) {
        assembly {
            let value := sload(c.slot) // 32 byte increments only
            // 0x0003000500000000000000000000000700000000000000000000000000000009
            let shifted := shr(224, value) // 28 bytes * 8 = 224 bits
            // 0x0000000000000000000000000000000000000000000000000000000000030005
            cval := and(0xffff, shifted)
            // 0x000000000000000000000000000000000000000000000000000000000000ffff
        }
    }
    
    function getSlot() external pure returns(uint256 slot) {
        assembly {
            slot := a.slot
        }
    }
    
    function getValueBySlotIndex(uint256 slotIndex) external view returns(bytes32 ret) {
        assembly {
            ret := sload(slotIndex)
        }
    }

    function getValYul() external view returns(uint256 r) {
        assembly {
            r := sload(val.slot)
        }
    }

    function setValueBySlotIndexAndVal(uint256 slotIndex, uint256 newVal) external {
        assembly {
            sstore(slotIndex, newVal)
        }
    }

    function setVal(uint256 v) external {
        val = v;
    }

    function getVal() external view returns(uint256) {
        return val;
    }
}
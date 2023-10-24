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
    uint8 public e=2;
    // end slot 3

    // bitwise masking
    // value and 0 = 0
    // value and 1 = value
    // value or  0 = value
    function setPacked(uint16 _newValue) public {
        assembly{
            // _newValue = 0x000000000000000000000000000000000000000000000000000000000000000a

            let oldValue := sload(c.slot)
            // oldValue = 0x0203000500000000000000000000000700000000000000000000000000000009

            let cleared := and(oldValue, 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            // oldValue =   0x0203000500000000000000000000000700000000000000000000000000000009
            // mask =       0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            // clearedC =   0x0203000000000000000000000000000700000000000000000000000000000009

            let shifted := shl(mul(c.offset, 8), _newValue)
            // shifted =    0x0000000a00000000000000000000000000000000000000000000000000000000

            let newValue := or(shifted, cleared)
            // shifted  =   0x0000000a00000000000000000000000000000000000000000000000000000000
            // clearedC =   0x0203000000000000000000000000000700000000000000000000000000000009
            // newValue =   0x0203000a00000000000000000000000700000000000000000000000000000009

            sstore(c.slot, newValue)
        }
    }

    // get slot and offset for variable c
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
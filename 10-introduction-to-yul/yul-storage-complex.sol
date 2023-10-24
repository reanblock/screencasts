// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract YulStorageComplex {
    uint256[3] fixedSizeArray; 
    uint256[] dynamicArray;
    uint8[] smallArray;

    mapping(uint256 => uint256) public simpleMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressToListMapping;
 
    constructor() {
        // arrays
        fixedSizeArray = [66,77,88];
        dynamicArray = [9,909,90909, 9999];
        smallArray = [8,88,255];

        // mappings
        simpleMapping[88] = 1;
        simpleMapping[99] = 2;

        nestedMapping[9][8] = 7;
        nestedMapping[99][88] = 77;
        addressToListMapping[0xC8BF81e2d65cba23635fAeDD18e2c08caD1c5271] = [55,44,33];
    }

    /* Mapping Functions */
    function getMappingValue(uint256 key) external view returns(uint256 value) {
        uint256 slot;
        assembly {
            slot := simpleMapping.slot
        }

        bytes32 dataLocation = keccak256(abi.encode(key, slot));

        assembly {
            value := sload(dataLocation)
        }
    }

    function getNestedMappingValue(uint256 key1, uint256 key2) external view returns(uint256 value) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }

        bytes32 dataLocation = keccak256(abi.encode(key2, keccak256(abi.encode(key1, slot))));

        assembly {
            value := sload(dataLocation)
        }
    }

    function getAddressMappedArrayLength() external view returns(uint256 value) {
        uint256 slot;
        assembly {
            slot := addressToListMapping.slot
        }

       bytes32 dataLocation = keccak256(abi.encode(0xC8BF81e2d65cba23635fAeDD18e2c08caD1c5271, slot));

        assembly {
            value := sload(dataLocation)
        }
    }

    function getAddressMappedArrayData(uint256 index) external view returns(uint256 value) {
        uint256 slot;
        assembly {
            slot := addressToListMapping.slot
        }

       bytes32 dataLocation = keccak256(abi.encode(keccak256(abi.encode(0xC8BF81e2d65cba23635fAeDD18e2c08caD1c5271, slot))));

        assembly {
            value := sload(add(dataLocation, index))
        }
    }

    /* Array Functions */
    function getValueFixedArray(uint256 index) external view returns (uint256 value) {
        assembly {
            value := sload(add(fixedSizeArray.slot, index))
        }
    }

    function getDynamicArrayLength() external view returns (uint256 length) {
        assembly {
            length := sload(dynamicArray.slot)
        }
    }

    function getDynamicArrayValue(uint256 index) external view returns(uint256 value) {
        uint256 arraySlot;
        assembly {
            arraySlot := dynamicArray.slot
        }

        bytes32 dataStartSlot = keccak256(abi.encode(arraySlot));
        assembly {
            value := sload(add(dataStartSlot, index))
        }
    }

    function getSmallArrayValue(uint256 index) external view returns(bytes32 value) {
        uint256 arraySlot;
        assembly {
            arraySlot := smallArray.slot
        }

        bytes32 dataStartSlot = keccak256(abi.encode(arraySlot));
        assembly {
            value := sload(add(dataStartSlot, index))
        }
    }
}
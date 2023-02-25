// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract YulTypes {
    function numberType() external pure returns(uint256) {
        uint256 x;

        assembly {
            x := 88
        }

        return x;
    }

    function hexType() external pure returns(uint256) {
        uint256 x;

        assembly {
            x := 0xc // 12
        }

        return x;
    }

    function stringType() external pure returns(string memory) {
        bytes32 str = "";

        assembly {
            str := "hello"
        }

        return string(abi.encode(str));
    }

    function boolType() external pure returns(bool) {
        bool b;

        assembly {
            b := 0
        }

        return b;
    }

    function addressType() external pure returns(address) {
        address addr;

        assembly {
            addr := 1
        }

        return addr;
    }
}
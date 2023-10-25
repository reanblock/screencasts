// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract YulLogging {
    event LogEventType1(uint256 indexed a, uint256 indexed b);
    event LogEventType2(uint256 indexed foo, uint256 bar);

    function solidityEmitEvent1() public {
        emit LogEventType1(111,222);
    }

    function yulEmitEvent1() public {
        // To emit the LogEventType1 event in Yul, we need to use 'log3' opcode:
        // log3(p, s, t1, t2, t3) -> log data mem[p…(p+s)) with topics t1, t2, t3

        // The first and second param denote the area of memory to return as the non-indexed 
        // arguments. Since we are not indexing any arguments we can set this to 0
        
        // The first topic, t1, is the hash of the event signature
        // The second topic, t2, is the indexed data 'a'
        // The second topic, t3, is the indexed data 'b'

        bytes32 signature = keccak256("LogEventType1(uint256,uint256)");
        assembly {
            log3(0,0,signature,999,888)
        }
    }

    function solidityEmitEvent2() public {
        emit LogEventType2(222,11);
    }

    function yulEmitEvent2() public {
        bytes32 signature = keccak256("LogEventType2(uint256,uint256)");
        assembly {
            // non-indexed values are first stored in memory
            mstore(0x00, 0x22) // store 34 at address 0x00
            // then the memory area is used as params to the logN function
            // to emit the non-indexed values as part of the event
            log2(0x00,0x20,signature,777)
        }
    }
}
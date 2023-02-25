contract YulOperations {
    function isPrimeNumber(uint256 n) public pure returns (bool isPrime) {
        isPrime = true;
        assembly {
            let halfN := add(div(n, 2), 1)
            let i:= 2 
            for { } lt(i, halfN) { } {
                if iszero(mod(n, i)) {
                    isPrime := 0
                    break
                }

                i := add(i, 1)
            }
        }
    }

    function checkTruthy() external pure returns (uint256 result) {
        result = 88;

        assembly {
            if 99 {
                result := 99
            }
        }

        return result; // 99
    }

    function checkFalsy() external pure returns (uint256 result) {
        result = 88;

        assembly {
            if 0 {
                result := 99
            }
        }

        return result; // 88
    }

    function checkNegation() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if iszero(0) {
                result := 2
            }
        }

        return result; // 2
    }

    function negationUsingNotUnsafe() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if not(0) {
                result := 2
            }
        }

        return result; // 2
    }

    function notZero() external pure returns (bytes32 r) {
        assembly {
            r := not(0) // 0xffff.....
        }
    }

    function negation2UsingNotUnsafe() external pure returns (uint256 result) {
        result = 1;

        assembly {
            if not(2) { // unsafe!
            // if iszero(2) { // use iszero instead!
                result := 2
            }
        }

        return result; // 2
    }

    function getMaximum(uint256 x, uint256 y) external pure returns (uint256 max) {
        assembly {
            if gt(x, y) {
                max := x
            } // no else so need another if
            if gt(y, x) {
                max := y
            } 
        }
    }
}
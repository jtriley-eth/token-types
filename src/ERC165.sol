// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

// ## ERC165 Type Wrapper
//
// This type wraps the address primitive type and contains functions to call the core ERC165 interface
// without allocating new memory. State transition functions also perform returndata validation.
//
// All external calls that fail will revert internally. This is to simplify the API.
type ERC165 is address;

using {
    supportsInterface,
    // -- operators
    eq as ==,
    neq as !=,
    gt as >,
    gte as >=,
    lt as <,
    lte as <=,
    add as +,
    sub as -,
    mul as *,
    div as /,
    mod as %,
    and as &,
    or as |,
    xor as ^,
    not as ~
} for ERC165 global;

// -------------------------------------------------------------------------------------------------
// Query ERC165.supportsInterface without allocating new memory.
//
// Procedures:
//      01. right shifts interface id by 32 bits to pack with the selector
//      02. store the packed supportsInterface selector and interface id in memory
//      03. staticcall supportsInterface, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function supportsInterface(ERC165 erc165, bytes4 interfaceId) view returns (bool output) {
    assembly {
        interfaceId := shr(0x20, interfaceId)

        mstore(0x00, or(interfaceId, 0x01ffc9a700000000000000000000000000000000000000000000000000000000))

        if iszero(staticcall(gas(), erc165, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC165 instances are equal, `false` otherwise.
function eq(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := eq(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC165 instances are not equal, `false` otherwise.
function neq(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := iszero(eq(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than `rhs`, `false` otherwise.
function gt(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := gt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
function gte(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := iszero(lt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than `rhs`, `false` otherwise.
function lt(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := lt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
function lte(ERC165 lhs, ERC165 rhs) pure returns (bool output) {
    assembly {
        output := iszero(gt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the sum of two ERC165 instances.
function add(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        output := add(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the difference of two ERC165 instances.
function sub(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        output := sub(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the product of two ERC165 instances.
function mul(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        if lhs {
            output := and(mul(lhs, rhs), 0xffffffffffffffffffffffffffffffffffffffff)
            if iszero(eq(div(output, lhs), rhs)) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the division of two ERC165 instances.
function div(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := div(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the modulus of two ERC165 instances.
function mod(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := mod(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise AND of two ERC165 instances.
function and(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        output := and(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise OR of two ERC165 instances.
function or(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        output := or(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise XOR of two ERC165 instances.
function xor(ERC165 lhs, ERC165 rhs) pure returns (ERC165 output) {
    assembly {
        output := xor(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise NOT of an ERC165 instance.
function not(ERC165 lhs) pure returns (ERC165 output) {
    assembly {
        output := and(not(lhs), 0xffffffffffffffffffffffffffffffffffffffff)
    }
}

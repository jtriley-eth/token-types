// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

// ## ERC6909 Type Wrapper
//
// This type wraps the address primitive type and contains methods to call the core ERC6909
// interface without allocating new memory.
//
// All external calls that fail will revert internally. This is to simplify the API.
type ERC6909 is address;

using {
    supportsInterface,
    balanceOf,
    allowance,
    isOperator,
    transfer,
    transferFrom,
    approve,
    setOperator,
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
} for ERC6909 global;

// -------------------------------------------------------------------------------------------------
// Query ERC6909.supportsInterface without allocating new memory.
//
// Procedures:
//      01. store supportsInterface selector in memory
//      02. store interfaceId in memory
//      03. staticcall supportsInterface, storing result at memory[0]; revert if it fails
//      04. return boolean from memory
function supportsInterface(ERC6909 erc6909, bytes4 interfaceId) view returns (bool output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x01ffc9a700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, interfaceId)

        if iszero(staticcall(gas(), erc6909, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC6909.balanceOf without allocating new memory.
//
// Procedures:
//      01. store balanceOf selector in memory
//      02. store owner in memory
//      03. store id in memory
//      04. staticcall balanceOf, storing result at memory[0]; revert if it fails
//      05. assign returned value to output
//      06. restore upper bits of the free memory pointer to zero
function balanceOf(ERC6909 erc6909, address owner, uint256 id) view returns (uint256 output) {
    assembly {
        mstore(0x00, 0x00fdd58e00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, id)

        if iszero(staticcall(gas(), erc6909, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC6909.allowance without allocating new memory.
//
// Procedures:
//      01. load free memory pointer from memory; cache as fmp
//      02. store allowance selector in memory
//      03. store owner in memory
//      04. store spender in memory
//      05. store id in memory
//      06. staticcall allowance, storing result at memory[0]; revert if it fails
//      07. assign returned value to output
//      08. restore free memory pointer to fmp
//      09. restore zero slot to zero
function allowance(ERC6909 erc6909, address owner, address spender, uint256 id) view returns (uint256 output) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0x598af9e700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, spender)

        mstore(0x44, id)

        if iszero(staticcall(gas(), erc6909, 0x00, 0x64, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC6909.isOperator without allocating new memory.
//
// Procedures:
//      01. store isOperator selector in memory
//      02. store owner in memory
//      03. store spender in memory
//      04. staticcall isOperator, storing result at memory[0]; revert if it fails
//      05. assign returned value to output
//      06. restore upper bits of the free memory pointer to zero
function isOperator(ERC6909 erc6909, address owner, address spender) view returns (bool output) {
    assembly {
        mstore(0x00, 0xb6363cf200000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, spender)

        if iszero(staticcall(gas(), erc6909, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC6909.transfer without allocating new memory.
//
// Procedures:
//      01. load free memory pointer from memory; cache as fmp
//      02. store transfer selector in memory
//      03. store receiver in memory
//      04. store id in memory
//      05. store amount in memory
//      06. call transfer; cache result as ok
//      07. bitwise and ok with return value
//      08. if ok is zero (falsy), revert
//      09. restore free memory pointer to fmp
//      10. restore zero slot to zero
function transfer(ERC6909 erc6909, address receiver, uint256 id, uint256 amount) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0x095bcdb600000000000000000000000000000000000000000000000000000000)

        mstore(0x04, receiver)

        mstore(0x24, id)

        mstore(0x44, amount)

        let ok := call(gas(), erc6909, 0x00, 0x00, 0x64, 0x00, 0x20)

        ok := and(ok, mload(0x00))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC6909.transferFrom without allocating new memory.
//
// Procedures:
//      01. load free memory pointer from memory; cache as fmp
//      02. load first word of allocated memory; cache as allocatedWord
//      03. store transferFrom selector in memory
//      04. store sender in memory
//      05. store receiver in memory
//      06. store id in memory
//      07. store amount in memory
//      08. call transferFrom; cache result as ok
//      09. bitwise and ok with return value
//      10. if ok is zero (falsy), revert
//      11. restore free memory pointer to fmp
//      12. restore zero slot to zero
//      13. restore first word of allocated memory to allocatedWord
function transferFrom(ERC6909 erc6909, address sender, address receiver, uint256 id, uint256 amount) {
    assembly {
        let fmp := mload(0x40)

        let allocatedWord := mload(0x80)

        mstore(0x00, 0xfe99049a00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, sender)

        mstore(0x24, receiver)

        mstore(0x44, id)

        mstore(0x64, amount)

        let ok := call(gas(), erc6909, 0x00, 0x00, 0x84, allocatedWord, 0x20)

        ok := and(ok, mload(allocatedWord))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)

        mstore(0x80, allocatedWord)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC6909.approve without allocating new memory.
//
// Procedures:
//      01. load free memory pointer from memory; cache as fmp
//      02. store approve selector in memory
//      03. store spender in memory
//      04. store id in memory
//      05. store amount in memory
//      06. call approve; cache result as ok
//      07. bitwise and ok with return value
//      08. if ok is zero (falsy), revert
//      09. restore free memory pointer to fmp
//      10. restore zero slot to zero
function approve(ERC6909 erc6909, address spender, uint256 id, uint256 amount) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0x426a849300000000000000000000000000000000000000000000000000000000)

        mstore(0x04, spender)

        mstore(0x24, id)

        mstore(0x44, amount)

        let ok := call(gas(), erc6909, 0x00, 0x00, 0x64, 0x00, 0x20)

        ok := and(ok, mload(0x00))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC6909.setOperator without allocating new memory.
//
// Procedures:
//      01. store setOperator selector in memory
//      02. store spender in memory
//      03. store approved in memory
//      04. call setOperator; cache result as ok
//      05. bitwise and ok with return value
//      06. if ok is zero (falsy), revert
//      07. restore upper bits of the free memory pointer to zero
function setOperator(ERC6909 erc6909, address spender, bool approved) {
    assembly {
        mstore(0x00, 0x558a729700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, spender)

        mstore(0x24, approved)

        let ok := call(gas(), erc6909, 0x00, 0x00, 0x44, 0x00, 0x20)

        ok := and(ok, mload(0x00))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC6909 instances are equal, `false` otherwise.
function eq(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := eq(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC6909 instances are not equal, `false` otherwise.
function neq(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := iszero(eq(lhs, rhs)) }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than `rhs`, `false` otherwise.
function gt(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := gt(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
function gte(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := iszero(lt(lhs, rhs))}
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than `rhs`, `false` otherwise.
function lt(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := lt(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
function lte(ERC6909 lhs, ERC6909 rhs) pure returns (bool output) {
    assembly { output := iszero(gt(lhs, rhs)) }
}

// -------------------------------------------------------------------------------------------------
// Returns the sum of two ERC6909 instances.
function add(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly {
        output := add(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the difference of two ERC6909 instances.
function sub(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly {
        output := sub(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the product of two ERC6909 instances.
function mul(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly {
        if lhs {
            output := and(mul(lhs, rhs), 0xffffffffffffffffffffffffffffffffffffffff)
            if iszero(eq(div(output, lhs), rhs)) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the division of two ERC6909 instances.
function div(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := div(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the modulus of two ERC6909 instances.
function mod(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := mod(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise AND of two ERC6909 instances.
function and(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly { output := and(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise OR of two ERC6909 instances.
function or(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly { output := or(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise XOR of two ERC6909 instances.
function xor(ERC6909 lhs, ERC6909 rhs) pure returns (ERC6909 output) {
    assembly { output := xor(lhs, rhs) }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise NOT of an ERC6909 instance.
function not(ERC6909 lhs) pure returns (ERC6909 output) {
    assembly { output := and(not(lhs), 0xffffffffffffffffffffffffffffffffffffffff) }
}

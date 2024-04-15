// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

// ## ERC721Receiver Type Wrapper
//
// This type wraps the address primitive type and contains functions to cal the ERC721Receiver
// interface without allocating new memory.
//
// The external codesize check is performed inside the `onERC721Received` and
// `onERC721ReceivedWithData` functions, so no validation prior to these functions is required.
type ERC721Receiver is address;

using {
    onERC721Received,
    onERC721ReceivedWithData,
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
} for ERC721Receiver global;

// -------------------------------------------------------------------------------------------------
// Call ERC721Receiver.onERC721Received on the receiver if the receiver is a contract.
//
// Procedures:
//      01. if receiver has a nonzero codesize:
//          a. load free memory pointer from memory; cache as fmp
//          b. store the function selector in memory
//          c. store the operator address in memory
//          d. store the sender address in memory
//          e. store the token id in memory
//          f. store the data offset in memory
//          g. store the data length (zero) in memory
//          h. call the receiver contract; cache result as ok
//          i. check that the return value is 32 bytes; compose with ok
//          j. check that the return value matches the expected selector; compose with ok
//          k. if ok is false, revert
//
// Notes:
//      - if receiver is not a contract, no action is taken.
//      - the call payload is constructed at the free memory pointer, but it does not update the
//        free memory pointer, allowing the memory to be reused.
function onERC721Received(ERC721Receiver receiver, address operator, address sender, uint256 id) {
    assembly ("memory-safe") {
        if extcodesize(receiver) {
            let fmp := mload(0x40)

            mstore(add(fmp, 0x00), 0x150b7a0200000000000000000000000000000000000000000000000000000000)

            mstore(add(fmp, 0x04), operator)

            mstore(add(fmp, 0x24), sender)

            mstore(add(fmp, 0x44), id)

            mstore(add(fmp, 0x64), 0x80)

            mstore(add(fmp, 0x84), 0x00)

            let ok := call(gas(), receiver, 0x00, fmp, 0xa4, 0x00, 0x20)

            ok := and(ok, eq(returndatasize(), 0x20))

            ok := and(ok, eq(mload(0x00), 0x150b7a0200000000000000000000000000000000000000000000000000000000))

            if iszero(ok) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC721Receiver.onERC721Received on the receiver if the receiver is a contract.
//
// Procedures:
//      01. if receiver has a nonzero codesize:
//          a. load free memory pointer from memory; cache as fmp
//          b. store the function selector in memory
//          c. store the operator address in memory
//          d. store the sender address in memory
//          e. store the token id in memory
//          f. store the data offset in memory
//          g. store the data length in memory
//          h. copy the data from calldata to memory
//          h. call the receiver contract; cache result as ok
//          i. check that the return value is 32 bytes; compose with ok
//          j. check that the return value matches the expected selector; compose with ok
//          k. if ok is false, revert
//
// Notes:
//      - if receiver is not a contract, no action is taken.
//      - the call payload is constructed at the free memory pointer, but it does not update the
//        free memory pointer, allowing the memory to be reused.
function onERC721ReceivedWithData(
    ERC721Receiver receiver,
    address operator,
    address sender,
    uint256 id,
    bytes calldata data
) {
    assembly ("memory-safe") {
        if extcodesize(receiver) {
            let fmp := mload(0x40)

            mstore(add(fmp, 0x00), 0x150b7a0200000000000000000000000000000000000000000000000000000000)

            mstore(add(fmp, 0x04), operator)

            mstore(add(fmp, 0x24), sender)

            mstore(add(fmp, 0x44), id)

            mstore(add(fmp, 0x64), 0x80)

            mstore(add(fmp, 0x84), data.length)

            calldatacopy(add(fmp, 0xa4), data.offset, data.length)

            let ok := call(gas(), receiver, 0x00, fmp, add(0xa4, data.length), 0x00, 0x20)

            ok := and(ok, eq(returndatasize(), 0x20))

            ok := and(ok, eq(mload(0x00), 0x150b7a0200000000000000000000000000000000000000000000000000000000))

            if iszero(ok) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC721Receiver instances are equal, `false` otherwise.
function eq(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := eq(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC721Receiver instances are not equal, `false` otherwise.
function neq(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := iszero(eq(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than `rhs`, `false` otherwise.
function gt(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := gt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
function gte(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := iszero(lt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than `rhs`, `false` otherwise.
function lt(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := lt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
function lte(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (bool output) {
    assembly {
        output := iszero(gt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the sum of two ERC721Receiver instances.
function add(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        output := add(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the difference of two ERC721Receiver instances.
function sub(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        output := sub(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the product of two ERC721Receiver instances.
function mul(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        if lhs {
            output := and(mul(lhs, rhs), 0xffffffffffffffffffffffffffffffffffffffff)
            if iszero(eq(div(output, lhs), rhs)) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the division of two ERC721Receiver instances.
function div(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := div(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the modulus of two ERC721Receiver instances.
function mod(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := mod(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise AND of two ERC721Receiver instances.
function and(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        output := and(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise OR of two ERC721Receiver instances.
function or(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        output := or(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise XOR of two ERC721Receiver instances.
function xor(ERC721Receiver lhs, ERC721Receiver rhs) pure returns (ERC721Receiver output) {
    assembly {
        output := xor(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise NOT of an ERC721Receiver instance.
function not(ERC721Receiver lhs) pure returns (ERC721Receiver output) {
    assembly {
        output := and(not(lhs), 0xffffffffffffffffffffffffffffffffffffffff)
    }
}

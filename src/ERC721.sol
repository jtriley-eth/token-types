// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

// ## ERC721 Type Wrapper
//
// This type wraps the address primitive type and contains methods to call the core ERC721 interface
// without allocating new memory. State transition methods also perform returndata validation.
//
// All external calls that fail will revert internally. This is to simplify the API.
type ERC721 is address;

using {
    supportsInterface,
    getApproved,
    isApprovedForAll,
    balanceOf,
    ownerOf,
    safeTransferFrom,
    transferFrom,
    approve,
    setApprovalForAll,
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
} for ERC721 global;

function supportsInterface(ERC721 erc721, bytes4 interfaceId) view returns (bool output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x01ffc9a700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, interfaceId)

        if iszero(staticcall(gas(), erc721, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

function getApproved(ERC721 erc721, uint256 tokenId) view returns (address output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x081812fc00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, tokenId)

        if iszero(staticcall(gas(), erc721, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

function isApprovedForAll(ERC721 erc721, address owner, address operator) view returns (bool output) {
    assembly {
        mstore(0x00, 0xe985e9c500000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, operator)

        if iszero(staticcall(gas(), erc721, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x24, 0x00)
    }
}

function balanceOf(ERC721 erc721, address owner) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x70a0823100000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        if iszero(staticcall(gas(), erc721, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

function ownerOf(ERC721 erc721, uint256 tokenId) view returns (address output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x6352211e00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, tokenId)

        if iszero(staticcall(gas(), erc721, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

function safeTransferFrom(ERC721 erc721, address sender, address receiver, uint256 tokenId, bytes memory data) {
    assembly {
        let fmp := mload(0x40)

        let dataLength := mload(data)

        switch dataLength
        case 0x00 {
            mstore(0x00, 0x42842e0e00000000000000000000000000000000000000000000000000000000)

            mstore(0x04, sender)

            mstore(0x24, receiver)

            mstore(0x44, tokenId)

            if iszero(call(gas(), erc721, 0x00, 0x00, 0x64, 0x00, 0x00)) { revert(0x00, 0x00) }

            mstore(0x40, fmp)

            mstore(0x60, 0x00)
        }
        default {
            mstore(add(fmp, 0x00), 0xb88d4fde00000000000000000000000000000000000000000000000000000000)

            mstore(add(fmp, 0x04), sender)

            mstore(add(fmp, 0x24), receiver)

            mstore(add(fmp, 0x44), tokenId)

            mstore(add(fmp, 0x64), 0x80)

            mcopy(add(fmp, 0x84), data, add(dataLength, 0x20))

            if iszero(call(gas(), erc721, 0x00, fmp, add(0xa4, dataLength), 0x00, 0x00)) { revert(0x00, 0x00) }
        }
    }
}

function transferFrom(ERC721 erc721, address sender, address receiver, uint256 tokenId) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0x23b872dd00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, sender)

        mstore(0x24, receiver)

        mstore(0x44, tokenId)

        if iszero(call(gas(), erc721, 0x00, 0x00, 0x64, 0x00, 0x00)) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

function approve(ERC721 erc721, address operator, uint256 tokenId) {
    assembly {
        mstore(0x00, 0x095ea7b300000000000000000000000000000000000000000000000000000000)

        mstore(0x04, operator)

        mstore(0x24, tokenId)

        if iszero(call(gas(), erc721, 0x00, 0x00, 0x44, 0x00, 0x00)) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

function setApprovalForAll(ERC721 erc721, address operator, bool approved) {
    assembly {
        mstore(0x00, 0xa22cb46500000000000000000000000000000000000000000000000000000000)

        mstore(0x04, operator)

        mstore(0x24, approved)

        if iszero(call(gas(), erc721, 0x00, 0x00, 0x44, 0x00, 0x00)) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC721 instances are equal, `false` otherwise.
function eq(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := eq(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC721 instances are not equal, `false` otherwise.
function neq(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := iszero(eq(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than `rhs`, `false` otherwise.
function gt(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := gt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
function gte(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := iszero(lt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than `rhs`, `false` otherwise.
function lt(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := lt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
function lte(ERC721 lhs, ERC721 rhs) pure returns (bool output) {
    assembly {
        output := iszero(gt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the sum of two ERC721 instances.
function add(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        output := add(lhs, rhs)

        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the difference of two ERC721 instances.
function sub(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        output := sub(lhs, rhs)

        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the product of two ERC721 instances.
function mul(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        if lhs {
            output := and(mul(lhs, rhs), 0xffffffffffffffffffffffffffffffffffffffff)

            if iszero(eq(div(output, lhs), rhs)) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the division of two ERC721 instances.
function div(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := div(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the modulus of two ERC721 instances.
function mod(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }

        output := mod(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise AND of two ERC721 instances.
function and(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        output := and(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise OR of two ERC721 instances.
function or(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        output := or(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise XOR of two ERC721 instances.
function xor(ERC721 lhs, ERC721 rhs) pure returns (ERC721 output) {
    assembly {
        output := xor(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise NOT of an ERC721 instance.
function not(ERC721 lhs) pure returns (ERC721 output) {
    assembly {
        output := and(not(lhs), 0xffffffffffffffffffffffffffffffffffffffff)
    }
}

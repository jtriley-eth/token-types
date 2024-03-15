// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.24;

// ## ERC20 Type Wrapper
//
// This type wraps the address primitive type and contains methods to call the core ERC20 interface
// without allocating new memory. State transition methods also perform returndata validation.
//
// All external calls that fail will revert internally. This is to simplify the API.
type ERC20 is address;

using { totalSupply, balanceOf, allowance, transfer, transferFrom, approve } for ERC20 global;

// -------------------------------------------------------------------------------------------------
// Query ERC20.totalSupply without allocating new memory.
// Procedures:
//      01. store totalSupply selector in memory
//      02. staticcall totalSupply, storing result at memory[0]; revert if it fails
//      03. return total supply from memory
function totalSupply(ERC20 erc20) view returns (uint256 supply) {
    assembly ("memory-safe") {
        mstore(0x00, 0x18160ddd00000000000000000000000000000000000000000000000000000000)

        if iszero(staticcall(gas(), erc20, 0x00, 0x04, 0x00, 0x20)) { revert(0x00, 0x00) }

        supply := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC20.balanceOf without allocating new memory.
// Procedures:
//      01. store balanceOf selector in memory
//      02. store owner address in memory
//      03. staticcall balanceOf, storing result at memory[0]; revert if it fails
//      04. return balance from memory
function balanceOf(ERC20 erc20, address owner) view returns (uint256 bal) {
    assembly ("memory-safe") {
        mstore(0x00, 0x70a0823100000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        if iszero(staticcall(gas(), erc20, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        bal := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC20.allowance without allocating new memory.
// Procedures:
//      01. store allowance selector in memory
//      02. store owner address in memory
//      03. store spender address in memory
//      04. staticcall allowance, storing result at memory[0]; revert if it fails
//      05. restore the upper bits of the free memory pointer to zero
//      06. return allowance from memory
function allowance(ERC20 erc20, address owner, address spender) view returns (uint256 allowed) {
    assembly ("memory-safe") {
        mstore(0x00, 0xdd62ed3e00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, spender)

        if iszero(staticcall(gas(), erc20, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)

        allowed := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC20.transfer without allocating new memory.
// Procedures:
//      01. store transfer selector in memory
//      02. store recipient address in memory
//      03. store amount in memory
//      04. call transfer, storing the returndata memory[0]; cache as `ok`
//      05. check that either no data was returned or the data returned is truthy; compose with `ok`
//      06. revert if `ok` is false
//      07. restore the upper bits of the free memory pointer to zero
function transfer(ERC20 erc20, address receiver, uint256 amount) {
    assembly ("memory-safe") {
        mstore(0x00, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, receiver)

        mstore(0x24, amount)

        let ok := call(gas(), erc20, 0x00, 0x00, 0x44, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC20.transferFrom without allocating new memory.
// Procedures:
//      01. load the free memory pointer; cache as `fmp`
//      02. store transferFrom selector in memory
//      03. store sender address in memory
//      04. store recipient address in memory
//      05. store amount in memory
//      06. call transferFrom, storing the returndata memory[0]; cache as `ok`
//      07. check that either no data was returned or the data returned is truthy; compose with `ok`
//      08. revert if `ok` is false
//      09. restore the free memory pointer to `fmp`
//      10. restore the null slot in memory to zero
function transferFrom(ERC20 erc20, address sender, address receiver, uint256 amount) {
    assembly ("memory-safe") {
        let fmp := mload(0x40)

        mstore(0x00, 0x23b872dd00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, sender)

        mstore(0x24, receiver)

        mstore(0x44, amount)

        let ok := call(gas(), erc20, 0x00, 0x00, 0x64, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC20.approve without allocating new memory.
// Procedures:
//      01. store approve selector in memory
//      02. store spender address in memory
//      03. store amount in memory
//      04. call approve, storing the returndata memory[0]; cache as `ok`
//      05. check that either no data was returned or the data returned is truthy; compose with `ok`
//      06. revert if `ok` is false
//      07. restore the upper bits of the free memory pointer to zero
function approve(ERC20 erc20, address spender, uint256 amount) {
    assembly ("memory-safe") {
        mstore(0x00, 0x095ea7b300000000000000000000000000000000000000000000000000000000)

        mstore(0x04, spender)

        mstore(0x24, amount)

        let ok := call(gas(), erc20, 0x00, 0x00, 0x44, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

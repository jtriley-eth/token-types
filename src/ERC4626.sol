// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

// ## ERC4626 Type Wrapper
//
// This type wraps the address primitive type and contains functions to call the core ERC4626 interface
// without allocating new memory. State transition functions also perform returndata validation.
//
// All external calls that fail will revert internally. This is to simplify the API.
type ERC4626 is address;

using {
    asset,
    totalAssets,
    convertToShares,
    convertToAssets,
    maxDeposit,
    previewDeposit,
    deposit,
    maxMint,
    previewMint,
    mint,
    maxWithdraw,
    previewWithdraw,
    withdraw,
    maxRedeem,
    previewRedeem,
    redeem,
    totalSupply,
    balanceOf,
    allowance,
    transfer,
    transferFrom,
    approve,
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
} for ERC4626 global;

// -------------------------------------------------------------------------------------------------
// Query ERC4626.asset without allocating new memory.
//
// Procedures:
//      01. store asset selector in memory
//      02. staticcall asset, storing result at memory[0]; revert if it fails
//      03. assign returned value to output
function asset(ERC4626 erc4626) view returns (address output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x38d52e0f00000000000000000000000000000000000000000000000000000000)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x04, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.totalAssets without allocating new memory.
//
// Procedures:
//      01. store totalAssets selector in memory
//      02. staticcall totalAssets, storing result at memory[0]; revert if it fails
//      03. assign returned value to output
function totalAssets(ERC4626 erc4626) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x01e1d11400000000000000000000000000000000000000000000000000000000)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x04, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.convertToShares without allocating new memory.
//
// Procedures:
//      01. store convertToShares selector in memory
//      02. store assets in memory
//      03. staticcall convertToShares, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function convertToShares(ERC4626 erc4626, uint256 assets) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xc6e6f59200000000000000000000000000000000000000000000000000000000)

        mstore(0x04, assets)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.convertToAssets without allocating new memory.
//
// Procedures:
//      01. store convertToAssets selector in memory
//      02. store shares in memory
//      03. staticcall convertToAssets, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function convertToAssets(ERC4626 erc4626, uint256 shares) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x07a2d13a00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, shares)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.maxDeposit without allocating new memory.
//
// Procedures:
//      01. store maxDeposit selector in memory
//      02. store receiver in memory
//      03. staticcall maxDeposit, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function maxDeposit(ERC4626 erc4626, address receiver) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x402d267d00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, receiver)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.previewDeposit without allocating new memory.
//
// Procedures:
//      01. store previewDeposit selector in memory
//      02. store assets in memory
//      03. staticcall previewDeposit, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function previewDeposit(ERC4626 erc4626, uint256 assets) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xef8b30f700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, assets)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.deposit without allocating new memory.
//
// Procedures:
//      01. store previewMint selector in memory
//      02. store receiver in memory
//      03. store assets in memory
//      04. call previewMint, storing result at memory[0]; revert if it fails
//      05. assign returned value to output
//      06. restore the upper bits of the free memory pointer to zero
function deposit(ERC4626 erc4626, uint256 assets, address receiver) returns (uint256 output) {
    assembly {
        mstore(0x00, 0x6e553f6500000000000000000000000000000000000000000000000000000000)

        mstore(0x04, assets)

        mstore(0x24, receiver)

        if iszero(call(gas(), erc4626, 0x00, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.maxMint without allocating new memory.
//
// Procedures:
//      01. store maxMint selector in memory
//      02. store receiver in memory
//      03. staticcall maxMint, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function maxMint(ERC4626 erc4626, address receiver) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xc63d75b600000000000000000000000000000000000000000000000000000000)

        mstore(0x04, receiver)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.previewMint without allocating new memory.
//
// Procedures:
//      01. store previewMint selector in memory
//      02. store shares in memory
//      03. staticcall previewMint, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function previewMint(ERC4626 erc4626, uint256 shares) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xb3d7f6b900000000000000000000000000000000000000000000000000000000)

        mstore(0x04, shares)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.mint without allocating new memory.
//
// Procedures:
//      01. store mint selector in memory
//      02. store shares in memory
//      03. store receiver in memory
//      04. call mint, storing result at memory[0]; revert if it fails
//      05. assign returned value to output
//      06. restore the upper bits of the free memory pointer to zero
function mint(ERC4626 erc4626, uint256 shares, address receiver) returns (uint256 output) {
    assembly {
        mstore(0x00, 0x94bf804d00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, shares)

        mstore(0x24, receiver)

        if iszero(call(gas(), erc4626, 0x00, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.maxWithdraw without allocating new memory.
//
// Procedures:
//      01. store maxWithdraw selector in memory
//      02. store owner in memory
//      03. staticcall maxWithdraw, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function maxWithdraw(ERC4626 erc4626, address owner) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xce96cb7700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.previewWithdraw without allocating new memory.
//
// Procedures:
//      01. store previewWithdraw selector in memory
//      02. store assets in memory
//      03. staticcall previewWithdraw, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function previewWithdraw(ERC4626 erc4626, uint256 assets) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x0a28a47700000000000000000000000000000000000000000000000000000000)

        mstore(0x04, assets)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.withdraw without allocating new memory.
//
// Procedures:
//      01. load free memory pointer; cache as fmp
//      02. store withdraw selector in memory
//      03. store assets in memory
//      04. store receiver in memory
//      05. store owner in memory
//      06. call withdraw, storing result at memory[0]; revert if it fails
//      07. assign returned value to output
//      08. restore the free memory pointer to fmp
//      09. restore zero slot to zero
function withdraw(ERC4626 erc4626, uint256 assets, address receiver, address owner) returns (uint256 output) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0xb460af9400000000000000000000000000000000000000000000000000000000)

        mstore(0x04, assets)

        mstore(0x24, receiver)

        mstore(0x44, owner)

        if iszero(call(gas(), erc4626, 0x00, 0x00, 0x64, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.maxRedeem without allocating new memory.
//
// Procedures:
//      01. store maxRedeem selector in memory
//      02. store owner in memory
//      03. staticcall maxRedeem, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function maxRedeem(ERC4626 erc4626, address owner) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0xd905777e00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.previewRedeem without allocating new memory.
//
// Procedures:
//      01. store previewRedeem selector in memory
//      02. store shares in memory
//      03. staticcall previewRedeem, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function previewRedeem(ERC4626 erc4626, uint256 shares) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x4cdad50600000000000000000000000000000000000000000000000000000000)

        mstore(0x04, shares)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.redeem without allocating new memory.
//
// Procedures:
//      01. load free memory pointer; cache as fmp
//      02. store redeem selector in memory
//      03. store shares in memory
//      04. store receiver in memory
//      05. store owner in memory
//      06. call redeem, storing result at memory[0]; revert if it fails
//      07. assign returned value to output
//      08. restore the free memory pointer to fmp
//      09. restore zero slot to zero
function redeem(ERC4626 erc4626, uint256 shares, address receiver, address owner) returns (uint256 output) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0xba08765200000000000000000000000000000000000000000000000000000000)

        mstore(0x04, shares)

        mstore(0x24, receiver)

        mstore(0x44, owner)

        if iszero(call(gas(), erc4626, 0x00, 0x00, 0x64, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.totalSupply without allocating new memory.
//
// Procedures:
//      01. store totalSupply selector in memory
//      02. staticcall totalSupply, storing result at memory[0]; revert if it fails
//      03. assign returned value to output
function totalSupply(ERC4626 erc4626) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x18160ddd00000000000000000000000000000000000000000000000000000000)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x04, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.balanceOf without allocating new memory.
//
// Procedures:
//      01. store balanceOf selector in memory
//      02. store owner address in memory
//      03. staticcall balanceOf, storing result at memory[0]; revert if it fails
//      04. assign returned value to output
function balanceOf(ERC4626 erc4626, address owner) view returns (uint256 output) {
    assembly ("memory-safe") {
        mstore(0x00, 0x70a0823100000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x24, 0x00, 0x20)) { revert(0x00, 0x00) }

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Query ERC4626.allowance without allocating new memory.
//
// Procedures:
//      01. store allowance selector in memory
//      02. store owner address in memory
//      03. store spender address in memory
//      04. staticcall allowance, storing result at memory[0]; revert if it fails
//      05. restore the upper bits of the free memory pointer to zero
//      06. assign returned value to output
function allowance(ERC4626 erc4626, address owner, address spender) view returns (uint256 output) {
    assembly {
        mstore(0x00, 0xdd62ed3e00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, owner)

        mstore(0x24, spender)

        if iszero(staticcall(gas(), erc4626, 0x00, 0x44, 0x00, 0x20)) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)

        output := mload(0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.transfer without allocating new memory.
//
// Procedures:
//      01. store transfer selector in memory
//      02. store recipient address in memory
//      03. store amount in memory
//      04. call transfer, storing the returndata memory[0]; cache as `ok`
//      05. check that either no data was returned or the data returned is truthy; compose with `ok`
//      06. revert if `ok` is false
//      07. restore the upper bits of the free memory pointer to zero
function transfer(ERC4626 erc4626, address receiver, uint256 amount) {
    assembly {
        mstore(0x00, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, receiver)

        mstore(0x24, amount)

        let ok := call(gas(), erc4626, 0x00, 0x00, 0x44, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.transferFrom without allocating new memory.
//
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
function transferFrom(ERC4626 erc4626, address sender, address receiver, uint256 amount) {
    assembly {
        let fmp := mload(0x40)

        mstore(0x00, 0x23b872dd00000000000000000000000000000000000000000000000000000000)

        mstore(0x04, sender)

        mstore(0x24, receiver)

        mstore(0x44, amount)

        let ok := call(gas(), erc4626, 0x00, 0x00, 0x64, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x40, fmp)

        mstore(0x60, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Call ERC4626.approve without allocating new memory.
//
// Procedures:
//      01. store approve selector in memory
//      02. store spender address in memory
//      03. store amount in memory
//      04. call approve, storing the returndata memory[0]; cache as `ok`
//      05. check that either no data was returned or the data returned is truthy; compose with `ok`
//      06. revert if `ok` is false
//      07. restore the upper bits of the free memory pointer to zero
function approve(ERC4626 erc4626, address spender, uint256 amount) {
    assembly {
        mstore(0x00, 0x095ea7b300000000000000000000000000000000000000000000000000000000)

        mstore(0x04, spender)

        mstore(0x24, amount)

        let ok := call(gas(), erc4626, 0x00, 0x00, 0x44, 0x00, 0x20)

        ok := and(ok, or(iszero(returndatasize()), mload(0x00)))

        if iszero(ok) { revert(0x00, 0x00) }

        mstore(0x24, 0x00)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC4626 instances are equal, `false` otherwise.
function eq(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := eq(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if the two ERC4626 instances are not equal, `false` otherwise.
function neq(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := iszero(eq(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than `rhs`, `false` otherwise.
function gt(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := gt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is greater than or equal to `rhs`, `false` otherwise.
function gte(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := iszero(lt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than `rhs`, `false` otherwise.
function lt(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := lt(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns `true` if `lhs` is less than or equal to `rhs`, `false` otherwise.
function lte(ERC4626 lhs, ERC4626 rhs) pure returns (bool output) {
    assembly {
        output := iszero(gt(lhs, rhs))
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the sum of two ERC4626 instances.
function add(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        output := add(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the difference of two ERC4626 instances.
function sub(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        output := sub(lhs, rhs)
        if gt(output, 0xffffffffffffffffffffffffffffffffffffffff) { revert(0x00, 0x00) }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the product of two ERC4626 instances.
function mul(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        if lhs {
            output := and(mul(lhs, rhs), 0xffffffffffffffffffffffffffffffffffffffff)
            if iszero(eq(div(output, lhs), rhs)) { revert(0x00, 0x00) }
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the division of two ERC4626 instances.
function div(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := div(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the modulus of two ERC4626 instances.
function mod(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        if iszero(rhs) { revert(0x00, 0x00) }
        output := mod(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise AND of two ERC4626 instances.
function and(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        output := and(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise OR of two ERC4626 instances.
function or(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        output := or(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise XOR of two ERC4626 instances.
function xor(ERC4626 lhs, ERC4626 rhs) pure returns (ERC4626 output) {
    assembly {
        output := xor(lhs, rhs)
    }
}

// -------------------------------------------------------------------------------------------------
// Returns the bitwise NOT of an ERC4626 instance.
function not(ERC4626 lhs) pure returns (ERC4626 output) {
    assembly {
        output := and(not(lhs), 0xffffffffffffffffffffffffffffffffffffffff)
    }
}

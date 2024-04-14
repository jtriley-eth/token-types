// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC4626 } from "../../src/ERC4626.sol";

contract ERC4626Handler {
    ERC4626 immutable erc4626;

    constructor(address _erc4626) {
        erc4626 = ERC4626.wrap(_erc4626);
    }

    function asset() external view returns (address) {
        return erc4626.asset();
    }

    function totalAssets() external view returns (uint256) {
        return erc4626.totalAssets();
    }

    function convertToShares(uint256 assets) external view returns (uint256) {
        return erc4626.convertToShares(assets);
    }

    function convertToAssets(uint256 shares) external view returns (uint256) {
        return erc4626.convertToAssets(shares);
    }

    function maxDeposit(address receiver) external view returns (uint256) {
        return erc4626.maxDeposit(receiver);
    }

    function previewDeposit(uint256 assets) external view returns (uint256) {
        return erc4626.previewDeposit(assets);
    }

    function deposit(uint256 assets, address receiver) external returns (uint256) {
        return erc4626.deposit(assets, receiver);
    }

    function maxMint(address receiver) external view returns (uint256) {
        return erc4626.maxMint(receiver);
    }

    function previewMint(uint256 shares) external view returns (uint256) {
        return erc4626.previewMint(shares);
    }

    function mint(uint256 shares, address receiver) external returns (uint256) {
        return erc4626.mint(shares, receiver);
    }

    function maxWithdraw(address receiver) external view returns (uint256) {
        return erc4626.maxWithdraw(receiver);
    }

    function previewWithdraw(uint256 assets) external view returns (uint256) {
        return erc4626.previewWithdraw(assets);
    }

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256) {
        return erc4626.withdraw(assets, receiver, owner);
    }

    function maxRedeem(address receiver) external view returns (uint256) {
        return erc4626.maxRedeem(receiver);
    }

    function previewRedeem(uint256 shares) external view returns (uint256) {
        return erc4626.previewRedeem(shares);
    }

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256) {
        return erc4626.redeem(shares, receiver, owner);
    }

    function totalSupply() external view returns (uint256) {
        return erc4626.totalSupply();
    }

    function balanceOf(address owner) external view returns (uint256) {
        return erc4626.balanceOf(owner);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return erc4626.allowance(owner, spender);
    }

    function transfer(address receiver, uint256 amount) external {
        erc4626.transfer(receiver, amount);
    }

    function transferFrom(address sender, address receiver, uint256 amount) external {
        erc4626.transferFrom(sender, receiver, amount);
    }

    function approve(address spender, uint256 amount) external {
        erc4626.approve(spender, amount);
    }
}

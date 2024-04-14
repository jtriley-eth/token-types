// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { MockERC20 } from "./MockERC20.sol";

contract MockERC4626 is MockERC20 {
    // note: these are not real 4626 events, they're to signal correct fn calls
    event Deposit(address indexed sender, address indexed owner, uint256 amount);
    event Mint(address indexed sender, address indexed owner, uint256 amount);
    event Withdraw(address indexed sender, address indexed receiver, address indexed owner, uint256 amount);
    event Redeem(address indexed sender, address indexed receiver, address indexed owner, uint256 amount);

    address internal _asset;
    uint256 internal _totalAssets;
    mapping(address => uint256) internal _maxDeposit;
    mapping(address => uint256) internal _maxMint;
    mapping(address => uint256) internal _maxWithdraw;
    mapping(address => uint256) internal _maxRedeem;

    function asset() external view returns (address) {
        if (shouldThrow) revert();
        return _asset;
    }

    function totalAssets() external view returns (uint256) {
        if (shouldThrow) revert();
        return _totalAssets;
    }

    function convertToShares(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        return assets;
    }

    function convertToAssets(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        return shares;
    }

    function maxDeposit(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        return _maxDeposit[receiver];
    }

    function previewDeposit(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        return assets;
    }

    function deposit(uint256 assets, address receiver) external returns (uint256) {
        if (shouldThrow) revert();
        emit Deposit(msg.sender, receiver, assets);
        return assets;
    }

    function maxMint(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        return _maxMint[receiver];
    }

    function previewMint(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        return shares;
    }

    function mint(uint256 shares, address receiver) external returns (uint256) {
        if (shouldThrow) revert();
        emit Mint(msg.sender, receiver, shares);
        return shares;
    }

    function maxWithdraw(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        return _maxWithdraw[receiver];
    }

    function previewWithdraw(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        return assets;
    }

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256) {
        if (shouldThrow) revert();
        emit Withdraw(msg.sender, receiver, owner, assets);
        return assets;
    }

    function maxRedeem(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        return _maxRedeem[receiver];
    }

    function previewRedeem(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        return shares;
    }

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256) {
        if (shouldThrow) revert();
        emit Redeem(msg.sender, receiver, owner, shares);
        return shares;
    }

    function setAsset(address asset_) external {
        _asset = asset_;
    }

    function setTotalAssets(uint256 totalAssets_) external {
        _totalAssets = totalAssets_;
    }

    function setMaxDeposit(address receiver, uint256 maxDeposit_) external {
        _maxDeposit[receiver] = maxDeposit_;
    }

    function setMaxMint(address receiver, uint256 maxMint_) external {
        _maxMint[receiver] = maxMint_;
    }

    function setMaxWithdraw(address receiver, uint256 maxWithdraw_) external {
        _maxWithdraw[receiver] = maxWithdraw_;
    }

    function setMaxRedeem(address receiver, uint256 maxRedeem_) external {
        _maxRedeem[receiver] = maxRedeem_;
    }
}

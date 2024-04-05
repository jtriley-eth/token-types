// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC20 } from "../../src/ERC20.sol";

contract ERC20Handler {
    ERC20 immutable erc20;

    constructor(address _erc20) {
        erc20 = ERC20.wrap(_erc20);
    }

    function totalSupply() external view returns (uint256) {
        return erc20.totalSupply();
    }

    function balanceOf(address owner) external view returns (uint256) {
        return erc20.balanceOf(owner);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return erc20.allowance(owner, spender);
    }

    function transfer(address receiver, uint256 amount) external {
        erc20.transfer(receiver, amount);
    }

    function transferFrom(address sender, address receiver, uint256 amount) external {
        erc20.transferFrom(sender, receiver, amount);
    }

    function approve(address spender, uint256 amount) external {
        erc20.approve(spender, amount);
    }
}

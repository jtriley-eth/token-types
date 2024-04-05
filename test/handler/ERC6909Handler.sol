// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC6909 } from "../../src/ERC6909.sol";

contract ERC6909Handler {
    ERC6909 immutable erc6909;

    constructor(address _erc6909) {
        erc6909 = ERC6909.wrap(_erc6909);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return erc6909.supportsInterface(interfaceId);
    }

    function balanceOf(address owner, uint256 id) external view returns (uint256) {
        return erc6909.balanceOf(owner, id);
    }

    function allowance(address owner, address spender, uint256 id) external view returns (uint256) {
        return erc6909.allowance(owner, spender, id);
    }

    function isOperator(address owner, address operator) external view returns (bool) {
        return erc6909.isOperator(owner, operator);
    }

    function transfer(address receiver, uint256 id, uint256 amount) external {
        erc6909.transfer(receiver, id, amount);
    }

    function transferFrom(address sender, address receiver, uint256 id, uint256 amount) external {
        erc6909.transferFrom(sender, receiver, id, amount);
    }

    function approve(address spender, uint256 id, uint256 amount) external {
        erc6909.approve(spender, id, amount);
    }

    function setOperator(address operator, bool approved) external {
        erc6909.setOperator(operator, approved);
    }
}

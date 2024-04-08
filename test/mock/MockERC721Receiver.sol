// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

contract MockERC721Receiver {
    event Received(address indexed operator, address indexed from, uint256 indexed tokenId, bytes data);

    bool public shouldThrow = false;
    bytes4 public returnValue = this.onERC721Received.selector;

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (shouldThrow) revert();
        emit Received(operator, from, tokenId, data);
        return returnValue;
    }

    function setShouldThrow(bool value) external {
        shouldThrow = value;
    }

    function setReturnValue(bytes4 value) external {
        returnValue = value;
    }
}

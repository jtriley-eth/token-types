// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

contract MockERC165 {
    bool public shouldThrow = false;

    mapping(bytes4 => bool) internal _supportsInterface;

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        if (shouldThrow) revert();
        return _supportsInterface[interfaceId];
    }

    function setShouldThrow(bool throws) external {
        shouldThrow = throws;
    }

    function setSupportsInterface(bytes4 interfaceId, bool value) external {
        _supportsInterface[interfaceId] = value;
    }
}

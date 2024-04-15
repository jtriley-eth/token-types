// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

contract MockERC165 {
    bool public shouldThrow = false;
    bool public shouldReturnAnything = true;

    mapping(bytes4 => bool) internal _supportsInterface;

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _supportsInterface[interfaceId];
        } else {
            assembly {
                stop()
            }
        }
    }

    function setSupportsInterface(bytes4 interfaceId, bool value) external {
        _supportsInterface[interfaceId] = value;
    }

    function setShouldThrow(bool throws) external {
        shouldThrow = throws;
    }

    function setShouldReturnAnything(bool _shouldReturnAnything) external {
        shouldReturnAnything = _shouldReturnAnything;
    }
}

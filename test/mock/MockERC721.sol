// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

contract MockERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event Approval(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event TransferWithData(address indexed from, address to, uint256 indexed id, bytes data);

    bool public shouldThrow = false;
    bool public shouldReturnAnything = true;

    mapping(uint256 => address) internal _ownerOf;
    mapping(address => uint256) internal _balanceOf;
    mapping(uint256 => address) internal _getApproved;
    mapping(bytes4 => bool) internal _supportsInterface;
    mapping(address => mapping(address => bool)) internal _isApprovedForAll;

    function ownerOf(uint256 id) public view returns (address owner) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _ownerOf[id];
        } else {
            assembly {
                stop()
            }
        }
    }

    function balanceOf(address owner) public view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _balanceOf[owner];
        } else {
            assembly {
                stop()
            }
        }
    }

    function getApproved(uint256 id) public view returns (address) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _getApproved[id];
        } else {
            assembly {
                stop()
            }
        }
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _isApprovedForAll[owner][operator];
        } else {
            assembly {
                stop()
            }
        }
    }

    function approve(address spender, uint256 id) public {
        if (shouldThrow) revert();

        emit Approval(msg.sender, spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public {
        if (shouldThrow) revert();

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) public {
        if (shouldThrow) revert();

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint256 id) public {
        if (shouldThrow) revert();

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public {
        if (shouldThrow) revert();

        // this is not a real event, just want to ensure the data comes through correctly.
        emit TransferWithData(from, to, id, data);
    }

    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _supportsInterface[interfaceId];
        } else {
            assembly {
                stop()
            }
        }
    }

    function setOwnerOf(uint256 id, address owner) public {
        _ownerOf[id] = owner;
    }

    function setBalanceOf(address owner, uint256 balance) public {
        _balanceOf[owner] = balance;
    }

    function setIsApprovedForAll(address owner, address operator, bool approved) public {
        _isApprovedForAll[owner][operator] = approved;
    }

    function setApproved(uint256 id, address approved) public {
        _getApproved[id] = approved;
    }

    function setSupportsInterface(bytes4 interfaceId, bool supported) public {
        _supportsInterface[interfaceId] = supported;
    }

    function setShouldThrow(bool _shouldThrow) public {
        shouldThrow = _shouldThrow;
    }

    function setShouldReturnAnything(bool _shouldReturnAnything) public {
        shouldReturnAnything = _shouldReturnAnything;
    }
}

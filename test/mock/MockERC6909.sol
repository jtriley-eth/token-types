// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

contract MockERC6909 {
    event OperatorSet(address indexed owner, address indexed operator, bool approved);
    event Approval(address indexed owner, address indexed spender, uint256 indexed id, uint256 amount);
    event Transfer(address caller, address indexed from, address indexed to, uint256 indexed id, uint256 amount);

    bool public shouldThrow = false;
    bool public returnValue = true;
    bool public shouldReturnAnything = true;

    mapping(bytes4 => bool) internal _supportsInterface;
    mapping(address => mapping(address => bool)) internal _operator;
    mapping(address => mapping(uint256 => uint256)) internal _balanceOf;
    mapping(address => mapping(address => mapping(uint256 => uint256))) internal _allowance;

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

    function balanceOf(address owner, uint256 id) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _balanceOf[owner][id];
        } else {
            assembly {
                stop()
            }
        }
    }

    function allowance(address owner, address spender, uint256 id) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _allowance[owner][spender][id];
        } else {
            assembly {
                stop()
            }
        }
    }

    function isOperator(address owner, address operator) external view returns (bool) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _operator[owner][operator];
        } else {
            assembly {
                stop()
            }
        }
    }

    function transfer(address receiver, uint256 id, uint256 amount) public returns (bool) {
        if (shouldThrow) revert();
        emit Transfer(msg.sender, msg.sender, receiver, id, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function transferFrom(address sender, address receiver, uint256 id, uint256 amount) public returns (bool) {
        if (shouldThrow) revert();
        emit Transfer(msg.sender, sender, receiver, id, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function approve(address spender, uint256 id, uint256 amount) public returns (bool) {
        if (shouldThrow) revert();
        emit Approval(msg.sender, spender, id, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function setOperator(address operator, bool approved) public returns (bool) {
        if (shouldThrow) revert();
        _operator[msg.sender][operator] = approved;
        emit OperatorSet(msg.sender, operator, approved);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function setSupportsInterface(bytes4 interfaceId, bool supported) public {
        _supportsInterface[interfaceId] = supported;
    }

    function setBalanceOf(address owner, uint256 id, uint256 amount) public {
        _balanceOf[owner][id] = amount;
    }

    function setAllowance(address owner, address spender, uint256 id, uint256 amount) public {
        _allowance[owner][spender][id] = amount;
    }

    function setIsOperator(address owner, address operator, bool approved) public {
        _operator[owner][operator] = approved;
    }

    function setShouldThrow(bool _shouldThrow) public {
        shouldThrow = _shouldThrow;
    }

    function setReturnValue(bool _returnValue) public {
        returnValue = _returnValue;
    }

    function setShouldReturnAnything(bool _shouldReturnAnything) public {
        shouldReturnAnything = _shouldReturnAnything;
    }
}

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.24;

contract MockERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    bool public shouldThrow = false;
    bool public returnValue = true;
    bool public shouldReturnAnything = true;

    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balanceOf;
    mapping(address => mapping(address => uint256)) internal _allowance;

    function totalSupply() external view returns (uint256) {
        if (shouldThrow) revert();
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        if (shouldThrow) revert();
        return _balanceOf[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        if (shouldThrow) revert();
        return _allowance[owner][spender];
    }

    function transfer(address receiver, uint256 amount) external returns (bool) {
        if (shouldThrow) revert();
        emit Transfer(msg.sender, receiver, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function transferFrom(address sender, address receiver, uint256 amount) external returns (bool) {
        if (shouldThrow) revert();
        emit Transfer(sender, receiver, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (shouldThrow) revert();
        emit Approval(msg.sender, spender, amount);
        if (shouldReturnAnything) {
            return returnValue;
        } else {
            assembly {
                stop()
            }
        }
    }

    function setTotalSupply(uint256 supply) external {
        _totalSupply = supply;
    }

    function setBalanceOf(address account, uint256 amount) external {
        _balanceOf[account] = amount;
    }

    function setAllowance(address owner, address spender, uint256 amount) external {
        _allowance[owner][spender] = amount;
    }

    function setShouldThrow(bool throws) external {
        shouldThrow = throws;
    }

    function setReturnValue(bool value) external {
        returnValue = value;
    }

    function setShouldReturnAnything(bool anything) external {
        shouldReturnAnything = anything;
    }

    fallback() external {
        return;
    }
}

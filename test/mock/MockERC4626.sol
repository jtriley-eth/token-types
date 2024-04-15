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
        if (shouldReturnAnything) {
            return _asset;
        } else {
            assembly {
                stop()
            }
        }
    }

    function totalAssets() external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _totalAssets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function convertToShares(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return assets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function convertToAssets(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return shares;
        } else {
            assembly {
                stop()
            }
        }
    }

    function maxDeposit(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _maxDeposit[receiver];
        } else {
            assembly {
                stop()
            }
        }
    }

    function previewDeposit(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return assets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function deposit(uint256 assets, address receiver) external returns (uint256) {
        if (shouldThrow) revert();
        emit Deposit(msg.sender, receiver, assets);
        if (shouldReturnAnything) {
            return assets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function maxMint(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _maxMint[receiver];
        } else {
            assembly {
                stop()
            }
        }
    }

    function previewMint(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return shares;
        } else {
            assembly {
                stop()
            }
        }
    }

    function mint(uint256 shares, address receiver) external returns (uint256) {
        if (shouldThrow) revert();
        emit Mint(msg.sender, receiver, shares);
        if (shouldReturnAnything) {
            return shares;
        } else {
            assembly {
                stop()
            }
        }
    }

    function maxWithdraw(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _maxWithdraw[receiver];
        } else {
            assembly {
                stop()
            }
        }
    }

    function previewWithdraw(uint256 assets) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return assets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256) {
        if (shouldThrow) revert();
        emit Withdraw(msg.sender, receiver, owner, assets);
        if (shouldReturnAnything) {
            return assets;
        } else {
            assembly {
                stop()
            }
        }
    }

    function maxRedeem(address receiver) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return _maxRedeem[receiver];
        } else {
            assembly {
                stop()
            }
        }
    }

    function previewRedeem(uint256 shares) external view returns (uint256) {
        if (shouldThrow) revert();
        if (shouldReturnAnything) {
            return shares;
        } else {
            assembly {
                stop()
            }
        }
    }

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256) {
        if (shouldThrow) revert();
        emit Redeem(msg.sender, receiver, owner, shares);
        if (shouldReturnAnything) {
            return shares;
        } else {
            assembly {
                stop()
            }
        }
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

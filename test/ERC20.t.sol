// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.24;

import { ERC20 } from "../src/ERC20.sol";
import { MockERC20 } from "./mock/MockERC20.sol";
import { ERC20Handler } from "./handler/ERC20Handler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC20Test is Test {
    MockERC20 internal mock;
    ERC20Handler internal handler;

    function setUp() public {
        mock = new MockERC20();
        handler = new ERC20Handler(address(mock));
    }

    function testTotalSupply() public {
        assertEq(handler.totalSupply(), 0);
        mock.setTotalSupply(1);
        assertEq(handler.totalSupply(), 1);
    }

    function testTotalSupplyFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.totalSupply();
    }

    function testFuzzTotalSupply(bool shouldThrow, uint256 supply) public {
        mock.setTotalSupply(supply);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.totalSupply();
        } else {
            assertEq(handler.totalSupply(), supply);
        }   
    }

    function testBalanceOf() public {
        assertEq(handler.balanceOf(address(0x01)), 0);
        mock.setBalanceOf(address(0x01), 1);
        assertEq(handler.balanceOf(address(0x01)), 1);
    }

    function testBalanceOfFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.balanceOf(address(0x01));
    }

    function testFuzzBalanceOf(bool shouldThrow, address account, uint256 balance) public {
        mock.setBalanceOf(account, balance);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.balanceOf(account);
        } else {
            assertEq(handler.balanceOf(account), balance);
        }
    }

    function testAllowance() public {
        assertEq(handler.allowance(address(0x01), address(0x02)), 0);
        mock.setAllowance(address(0x01), address(0x02), 1);
        assertEq(handler.allowance(address(0x01), address(0x02)), 1);
    }

    function testAllowanceFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.allowance(address(0x01), address(0x02));
    }

    function testFuzzAllowance(bool shouldThrow, address owner, address spender, uint256 allowance) public {
        mock.setAllowance(owner, spender, allowance);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.allowance(owner, spender);
        } else {
            assertEq(handler.allowance(owner, spender), allowance);
        }
    }

    function testTransfer() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Transfer(address(handler), address(0x01), 1);

        handler.transfer(address(0x01), 1);
    }

    function testTransferReturnsNothing() public {
        mock.setShouldReturnAnything(false);

        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Transfer(address(handler), address(0x01), 1);

        handler.transfer(address(0x01), 1);
    }

    function testTransferFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.transfer(address(0x01), 1);
    }

    function testTransferReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.transfer(address(0x01), 1);
    }

    function testFuzzTransfer(
        bool shouldThrow,
        bool returnValue,
        bool shouldReturnAnything,
        address receiver,
        uint256 amount
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        mock.setShouldReturnAnything(shouldReturnAnything);

        if (!shouldThrow && (returnValue || !shouldReturnAnything)) {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC20.Transfer(address(handler), receiver, amount);
            handler.transfer(receiver, amount);
        } else {
            vm.expectRevert();
            handler.transfer(receiver, amount);
        }
    }

    function testTransferFrom() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Transfer(address(0x01), address(0x02), 1);

        handler.transferFrom(address(0x01), address(0x02), 1);
    }

    function testTransferFromReturnsNothing() public {
        mock.setShouldReturnAnything(false);

        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Transfer(address(0x01), address(0x02), 1);

        handler.transferFrom(address(0x01), address(0x02), 1);
    }

    function testTransferFromFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.transferFrom(address(0x01), address(0x02), 1);
    }

    function testTransferFromReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.transferFrom(address(0x01), address(0x02), 1);
    }

    function testFuzzTransferFrom(
        bool shouldThrow,
        bool returnValue,
        bool shouldReturnAnything,
        address sender,
        address receiver,
        uint256 amount
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        mock.setShouldReturnAnything(shouldReturnAnything);

        if (!shouldThrow && (returnValue || !shouldReturnAnything)) {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC20.Transfer(sender, receiver, amount);
            handler.transferFrom(sender, receiver, amount);
        } else {
            vm.expectRevert();
            handler.transferFrom(sender, receiver, amount);
        }
    }

    function testApprove() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Approval(address(handler), address(0x01), 1);

        handler.approve(address(0x01), 1);
    }

    function testApproveReturnsNothing() public {
        mock.setShouldReturnAnything(false);

        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC20.Approval(address(handler), address(0x01), 1);

        handler.approve(address(0x01), 1);
    }

    function testApproveFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.approve(address(0x02), 1);
    }

    function testApproveReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.approve(address(0x02), 1);
    }

    function testFuzzApprove(
        bool shouldThrow,
        bool returnValue,
        bool shouldReturnAnything,
        address spender,
        uint256 amount
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        mock.setShouldReturnAnything(shouldReturnAnything);

        if (!shouldThrow && (returnValue || !shouldReturnAnything)) {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC20.Approval(address(handler), spender, amount);
            handler.approve(spender, amount);
        } else {
            vm.expectRevert();
            handler.approve(spender, amount);
        }
    }
}

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC6909 } from "../src/ERC6909.sol";
import { MockERC6909 } from "./mock/MockERC6909.sol";
import { ERC6909Handler } from "./handler/ERC6909Handler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC6909Test is Test {
    MockERC6909 internal mock;
    ERC6909Handler internal handler;

    function setUp() public {
        mock = new MockERC6909();
        handler = new ERC6909Handler(address(mock));
    }

    function testSupportsInterface() public {
        mock.setSupportsInterface(0xffffffff, true);
        assertTrue(handler.supportsInterface(0xffffffff));
    }

    function testSupportsInterfaceFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.supportsInterface(0xffffffff);
    }

    function testFuzzSupportsInterface(bool shouldThrow, bytes4 interfaceId, bool supportsInterface) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.supportsInterface(interfaceId);
        } else {
            mock.setSupportsInterface(interfaceId, supportsInterface);
            assertEq(handler.supportsInterface(interfaceId), supportsInterface);
        }
    }

    function testBalanceOf() public {
        mock.setBalanceOf(address(this), 1, 2);
        assertEq(handler.balanceOf(address(this), 1), 2);
    }

    function testBalanceOfFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.balanceOf(address(this), 0);
    }

    function testFuzzBalanceOf(bool shouldThrow, address owner, uint256 id, uint256 balance) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.balanceOf(owner, id);
        } else {
            mock.setBalanceOf(owner, id, balance);
            assertEq(handler.balanceOf(owner, id), balance);
        }
    }

    function testAllowance() public {
        mock.setAllowance(address(this), address(this), 1, 2);
        assertEq(handler.allowance(address(this), address(this), 1), 2);
    }

    function testAllowanceFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.allowance(address(this), address(this), 0);
    }

    function testFuzzAllowance(
        bool shouldThrow,
        address owner,
        address spender,
        uint256 id,
        uint256 allowance
    ) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.allowance(owner, spender, id);
        } else {
            mock.setAllowance(owner, spender, id, allowance);
            assertEq(handler.allowance(owner, spender, id), allowance);
        }
    }

    function testIsOperator() public {
        mock.setIsOperator(address(this), address(this), true);
        assertTrue(handler.isOperator(address(this), address(this)));
    }

    function testIsOperatorFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.isOperator(address(this), address(this));
    }

    function testFuzzIsOperator(bool shouldThrow, address owner, address operator, bool isOperator) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.isOperator(owner, operator);
        } else {
            mock.setIsOperator(owner, operator, isOperator);
            assertEq(handler.isOperator(owner, operator), isOperator);
        }
    }

    function testTransfer() public {
        mock.setReturnValue(true);
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC6909.Transfer(address(handler), address(handler), address(0x01), 2, 3);

        handler.transfer(address(0x01), 2, 3);
    }

    function testTransferFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.transfer(address(0x01), 2, 3);
    }

    function testTransferReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.transfer(address(0x01), 2, 3);
    }

    function testFuzzTransfer(
        bool shouldThrow,
        bool returnValue,
        address receiver,
        uint256 id,
        uint256 amount
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        if (shouldThrow || !returnValue) {
            vm.expectRevert();
            handler.transfer(receiver, id, amount);
        } else {
            vm.expectEmit(returnValue, true, true, true, address(mock));
            emit MockERC6909.Transfer(address(handler), address(handler), receiver, id, amount);
            handler.transfer(receiver, id, amount);
        }
    }

    function testTransferFrom() public {
        mock.setReturnValue(true);
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC6909.Transfer(address(handler), address(0x01), address(0x02), 3, 4);

        handler.transferFrom(address(0x01), address(0x02), 3, 4);
    }

    function testTransferFromFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.transferFrom(address(0x01), address(0x02), 3, 4);
    }

    function testTransferFromReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.transferFrom(address(0x01), address(0x02), 3, 4);
    }

    function testFuzzTransferFrom(
        bool shouldThrow,
        bool returnValue,
        address sender,
        address receiver,
        uint256 id,
        uint256 amount
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        if (shouldThrow || !returnValue) {
            vm.expectRevert();
            handler.transferFrom(sender, receiver, id, amount);
        } else {
            vm.expectEmit(returnValue, true, true, true, address(mock));
            emit MockERC6909.Transfer(address(handler), sender, receiver, id, amount);
            handler.transferFrom(sender, receiver, id, amount);
        }
    }

    function testApprove() public {
        mock.setReturnValue(true);
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC6909.Approval(address(handler), address(0x01), 2, 3);

        handler.approve(address(0x01), 2, 3);
    }

    function testApproveFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.approve(address(0x01), 2, 3);
    }

    function testApproveReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.approve(address(0x01), 2, 3);
    }

    function testFuzzApprove(bool shouldThrow, bool returnValue, address spender, uint256 id, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        if (shouldThrow || !returnValue) {
            vm.expectRevert();
            handler.approve(spender, id, amount);
        } else {
            vm.expectEmit(returnValue, true, true, true, address(mock));
            emit MockERC6909.Approval(address(handler), spender, id, amount);
            handler.approve(spender, id, amount);
        }
    }

    function testSetOperator() public {
        mock.setReturnValue(true);
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC6909.OperatorSet(address(handler), address(0x01), true);

        handler.setOperator(address(0x01), true);
    }

    function testSetOperatorFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.setOperator(address(0x01), true);
    }

    function testSetOperatorReturnsFalse() public {
        mock.setReturnValue(false);
        vm.expectRevert();
        handler.setOperator(address(0x01), true);
    }

    function testFuzzSetOperator(bool shouldThrow, bool returnValue, address operator, bool approved) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(returnValue);
        if (shouldThrow || !returnValue) {
            vm.expectRevert();
            handler.setOperator(operator, approved);
        } else {
            vm.expectEmit(returnValue, true, true, true, address(mock));
            emit MockERC6909.OperatorSet(address(handler), operator, approved);
            handler.setOperator(operator, approved);
        }
    }

    function testEq() public pure {
        assertTrue(ERC6909.wrap(address(1)) == ERC6909.wrap(address(1)));

        assertFalse(ERC6909.wrap(address(1)) == ERC6909.wrap(address(2)));
    }

    function testFuzzEq(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) == ERC6909.unwrap(b)) {
            assertTrue(a == b);
        } else {
            assertFalse(a == b);
        }
    }

    function testNeq() public pure {
        assertTrue(ERC6909.wrap(address(1)) != ERC6909.wrap(address(2)));

        assertFalse(ERC6909.wrap(address(1)) != ERC6909.wrap(address(1)));
    }

    function testFuzzNeq(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) != ERC6909.unwrap(b)) {
            assertTrue(a != b);
        } else {
            assertFalse(a != b);
        }
    }

    function testGt() public pure {
        assertTrue(ERC6909.wrap(address(2)) > ERC6909.wrap(address(1)));

        assertFalse(ERC6909.wrap(address(1)) > ERC6909.wrap(address(2)));
    }

    function testFuzzGt(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) > ERC6909.unwrap(b)) {
            assertTrue(a > b);
        } else {
            assertFalse(a > b);
        }
    }

    function testGte() public pure {
        assertTrue(ERC6909.wrap(address(2)) >= ERC6909.wrap(address(1)));

        assertFalse(ERC6909.wrap(address(1)) >= ERC6909.wrap(address(2)));

        assertTrue(ERC6909.wrap(address(1)) >= ERC6909.wrap(address(1)));
    }

    function testFuzzGte(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) >= ERC6909.unwrap(b)) {
            assertTrue(a >= b);
        } else {
            assertFalse(a >= b);
        }
    }

    function testLt() public pure {
        assertTrue(ERC6909.wrap(address(1)) < ERC6909.wrap(address(2)));

        assertFalse(ERC6909.wrap(address(2)) < ERC6909.wrap(address(1)));
    }

    function testFuzzLt(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) < ERC6909.unwrap(b)) {
            assertTrue(a < b);
        } else {
            assertFalse(a < b);
        }
    }

    function testLte() public pure {
        assertTrue(ERC6909.wrap(address(1)) <= ERC6909.wrap(address(2)));

        assertFalse(ERC6909.wrap(address(2)) <= ERC6909.wrap(address(1)));

        assertTrue(ERC6909.wrap(address(1)) <= ERC6909.wrap(address(1)));
    }

    function testFuzzLte(ERC6909 a, ERC6909 b) public pure {
        if (ERC6909.unwrap(a) <= ERC6909.unwrap(b)) {
            assertTrue(a <= b);
        } else {
            assertFalse(a <= b);
        }
    }

    function testAdd() public pure {
        assertTrue(ERC6909.wrap(address(1)) + ERC6909.wrap(address(2)) == ERC6909.wrap(address(3)));
    }

    function testAddOverflow() public {
        vm.expectRevert();
        ERC6909.wrap(address(type(uint160).max)) + ERC6909.wrap(address(1));
    }

    function testFuzzAdd(ERC6909 a, ERC6909 b, ERC6909 c) public {
        if (type(uint160).max - asU160(a) < asU160(b)) {
            vm.expectRevert();
            a + b;
        } else if (asU160(a) + asU160(b) == asU160(c)) {
            assertTrue(a + b == c);
        } else {
            assertFalse(a + b == c);
        }
    }

    function testSub() public pure {
        assertTrue(ERC6909.wrap(address(3)) - ERC6909.wrap(address(2)) == ERC6909.wrap(address(1)));
    }

    function testSubUnderflow() public {
        vm.expectRevert();
        ERC6909.wrap(address(1)) - ERC6909.wrap(address(2));
    }

    function testFuzzSub(ERC6909 a, ERC6909 b, ERC6909 c) public {
        if (asU160(a) < asU160(b)) {
            vm.expectRevert();
            a - b;
        } else if (asU160(a) - asU160(b) == asU160(c)) {
            assertTrue(a - b == c);
        } else {
            assertFalse(a - b == c);
        }
    }

    function testMul() public pure {
        assertTrue(ERC6909.wrap(address(2)) * ERC6909.wrap(address(3)) == ERC6909.wrap(address(6)));
    }

    function testMulOverflow() public {
        vm.expectRevert();
        ERC6909.wrap(address(type(uint160).max)) * ERC6909.wrap(address(2));
    }

    function testFuzzMul(ERC6909 a, ERC6909 b, ERC6909 c) public {
        if (asU160(a) > 0 && type(uint160).max / asU160(a) < asU160(b)) {
            vm.expectRevert();
            a * b;
        } else if (asU160(a) * asU160(b) == asU160(c)) {
            assertTrue(a * b == c);
        } else {
            assertFalse(a * b == c);
        }
    }

    function testDiv() public pure {
        assertTrue(ERC6909.wrap(address(6)) / ERC6909.wrap(address(3)) == ERC6909.wrap(address(2)));
    }

    function testDivByZero() public {
        vm.expectRevert();
        ERC6909.wrap(address(1)) / ERC6909.wrap(address(0));
    }

    function testFuzzDiv(ERC6909 a, ERC6909 b, ERC6909 c) public {
        if (asU160(b) == 0) {
            vm.expectRevert();
            a / b;
        } else if (asU160(a) / asU160(b) == asU160(c)) {
            assertTrue(a / b == c);
        } else {
            assertFalse(a / b == c);
        }
    }

    function testMod() public pure {
        assertTrue(ERC6909.wrap(address(6)) % ERC6909.wrap(address(4)) == ERC6909.wrap(address(2)));
    }

    function testModByZero() public {
        vm.expectRevert();
        ERC6909.wrap(address(1)) % ERC6909.wrap(address(0));
    }

    function testFuzzMod(ERC6909 a, ERC6909 b, ERC6909 c) public {
        if (asU160(b) == 0) {
            vm.expectRevert();
            a % b;
        } else if (asU160(a) % asU160(b) == asU160(c)) {
            assertTrue(a % b == c);
        } else {
            assertFalse(a % b == c);
        }
    }

    function testAnd() public pure {
        assertTrue(ERC6909.wrap(address(0x03)) & ERC6909.wrap(address(0x02)) == ERC6909.wrap(address(0x02)));
    }

    function testFuzzAnd(ERC6909 a, ERC6909 b, ERC6909 c) public pure {
        if (asU160(a) & asU160(b) == asU160(c)) {
            assertTrue(a & b == c);
        } else {
            assertFalse(a & b == c);
        }
    }

    function testOr() public pure {
        assertTrue(ERC6909.wrap(address(0x03)) | ERC6909.wrap(address(0x02)) == ERC6909.wrap(address(0x03)));
    }

    function testFuzzOr(ERC6909 a, ERC6909 b, ERC6909 c) public pure {
        if (asU160(a) | asU160(b) == asU160(c)) {
            assertTrue(a | b == c);
        } else {
            assertFalse(a | b == c);
        }
    }

    function testXor() public pure {
        assertTrue(ERC6909.wrap(address(0x03)) ^ ERC6909.wrap(address(0x02)) == ERC6909.wrap(address(0x01)));
    }

    function testFuzzXor(ERC6909 a, ERC6909 b, ERC6909 c) public pure {
        if (asU160(a) ^ asU160(b) == asU160(c)) {
            assertTrue(a ^ b == c);
        } else {
            assertFalse(a ^ b == c);
        }
    }

    function testNot() public pure {
        assertTrue(~ERC6909.wrap(address(0x03)) == ERC6909.wrap(address(0xFfFfFfFFfFFFFfffffFfFfFffffffFFfFFFfFFfc)));
    }

    function testFuzzNot(ERC6909 a) public pure {
        uint160 inverse = ~asU160(a);

        assertTrue(~a == ERC6909.wrap(address(inverse)));
    }

    function asU160(ERC6909 a) public pure returns (uint160) {
        return uint160(ERC6909.unwrap(a));
    }
}

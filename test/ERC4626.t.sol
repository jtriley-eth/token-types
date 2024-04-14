// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC4626 } from "../src/ERC4626.sol";
import { MockERC4626, MockERC20 } from "./mock/MockERC4626.sol";
import { ERC4626Handler } from "./handler/ERC4626Handler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC4626Test is Test {
    MockERC4626 internal mock;
    ERC4626Handler internal handler;

    function setUp() public {
        mock = new MockERC4626();
        handler = new ERC4626Handler(address(mock));
    }

    function testAsset() public {
        mock.setAsset(address(0x01));
        assertEq(handler.asset(), address(0x01));
    }

    function testAssetFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.asset();
    }

    function testFuzzAsset(bool shouldThrow, address asset) public {
        mock.setAsset(asset);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.asset();
        } else {
            assertEq(handler.asset(), asset);
        }
    }

    function testTotalAssets() public {
        mock.setTotalAssets(1);
        assertEq(handler.totalAssets(), 1);
    }

    function testTotalAssetsFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.totalAssets();
    }

    function testFuzzTotalAssets(bool shouldThrow, uint256 totalAssets) public {
        mock.setTotalAssets(totalAssets);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.totalAssets();
        } else {
            assertEq(handler.totalAssets(), totalAssets);
        }
    }

    function testConvertToShares() public view {
        assertEq(handler.convertToShares(1), 1);
    }

    function testConvertToSharesFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.convertToShares(1);
    }

    function testFuzzConvertToShares(bool shouldThrow, uint256 assets) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.convertToShares(assets);
        } else {
            assertEq(handler.convertToShares(assets), assets);
        }
    }

    function testConvertToAssets() public view {
        assertEq(handler.convertToAssets(1), 1);
    }

    function testConvertToAssetsFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.convertToAssets(1);
    }

    function testFuzzConvertToAssets(bool shouldThrow, uint256 shares) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.convertToAssets(shares);
        } else {
            assertEq(handler.convertToAssets(shares), shares);
        }
    }

    function testMaxDeposit() public {
        mock.setMaxDeposit(address(0x01), 2);
        assertEq(handler.maxDeposit(address(0x01)), 2);
    }

    function testMaxDepositFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.maxDeposit(address(0x01));
    }

    function testFuzzMaxDeposit(bool shouldThrow, address account, uint256 maxDeposit) public {
        mock.setMaxDeposit(account, maxDeposit);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.maxDeposit(account);
        } else {
            assertEq(handler.maxDeposit(account), maxDeposit);
        }
    }

    function testPreviewDeposit() public view {
        assertEq(handler.previewDeposit(1), 1);
    }

    function testPreviewDepositFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.previewDeposit(1);
    }

    function testFuzzPreviewDeposit(bool shouldThrow, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.previewDeposit(amount);
        } else {
            assertEq(handler.previewDeposit(amount), amount);
        }
    }

    function testDeposit() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC4626.Deposit(address(handler), address(0x02), 1);

        handler.deposit(1, address(0x02));
    }

    function testDepositFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.deposit(1, address(0x02));
    }

    function testFuzzDeposit(bool shouldThrow, address account, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.deposit(amount, account);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC4626.Deposit(address(handler), account, amount);

            handler.deposit(amount, account);
        }
    }

    function testMaxMint() public {
        mock.setMaxMint(address(0x01), 2);
        assertEq(handler.maxMint(address(0x01)), 2);
    }

    function testMaxMintFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.maxMint(address(0x01));
    }

    function testFuzzMaxMint(bool shouldThrow, address account, uint256 maxMint) public {
        mock.setMaxMint(account, maxMint);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.maxMint(account);
        } else {
            assertEq(handler.maxMint(account), maxMint);
        }
    }

    function testPreviewMint() public view {
        assertEq(handler.previewMint(1), 1);
    }

    function testPreviewMintFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.previewMint(1);
    }

    function testFuzzPreviewMint(bool shouldThrow, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.previewMint(amount);
        } else {
            assertEq(handler.previewMint(amount), amount);
        }
    }

    function testMint() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC4626.Mint(address(handler), address(0x02), 1);

        handler.mint(1, address(0x02));
    }

    function testMintFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.mint(1, address(0x02));
    }

    function testFuzzMint(bool shouldThrow, address account, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.mint(amount, account);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC4626.Mint(address(handler), account, amount);

            handler.mint(amount, account);
        }
    }

    function testMaxWithdraw() public {
        mock.setMaxWithdraw(address(0x01), 2);
        assertEq(handler.maxWithdraw(address(0x01)), 2);
    }

    function testMaxWithdrawFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.maxWithdraw(address(0x01));
    }

    function testFuzzMaxWithdraw(bool shouldThrow, address account, uint256 maxWithdraw) public {
        mock.setMaxWithdraw(account, maxWithdraw);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.maxWithdraw(account);
        } else {
            assertEq(handler.maxWithdraw(account), maxWithdraw);
        }
    }

    function testPreviewWithdraw() public view {
        assertEq(handler.previewWithdraw(1), 1);
    }

    function testPreviewWithdrawFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.previewWithdraw(1);
    }

    function testFuzzPreviewWithdraw(bool shouldThrow, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.previewWithdraw(amount);
        } else {
            assertEq(handler.previewWithdraw(amount), amount);
        }
    }

    function testWithdraw() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC4626.Withdraw(address(handler), address(0x02), address(0x03), 1);

        handler.withdraw(1, address(0x02), address(0x03));
    }

    function testWithdrawFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.withdraw(1, address(0x02), address(0x03));
    }

    function testFuzzWithdraw(bool shouldThrow, address receiver, address owner, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.withdraw(amount, receiver, owner);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC4626.Withdraw(address(handler), receiver, owner, amount);

            handler.withdraw(amount, receiver, owner);
        }
    }

    function testMaxRedeem() public {
        mock.setMaxRedeem(address(0x01), 2);
        assertEq(handler.maxRedeem(address(0x01)), 2);
    }

    function testMaxRedeemFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.maxRedeem(address(0x01));
    }

    function testFuzzMaxRedeem(bool shouldThrow, address account, uint256 maxRedeem) public {
        mock.setMaxRedeem(account, maxRedeem);
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.maxRedeem(account);
        } else {
            assertEq(handler.maxRedeem(account), maxRedeem);
        }
    }

    function testPreviewRedeem() public view {
        assertEq(handler.previewRedeem(1), 1);
    }

    function testPreviewRedeemFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.previewRedeem(1);
    }

    function testFuzzPreviewRedeem(bool shouldThrow, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.previewRedeem(amount);
        } else {
            assertEq(handler.previewRedeem(amount), amount);
        }
    }

    function testRedeem() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC4626.Redeem(address(handler), address(0x02), address(0x03), 1);

        handler.redeem(1, address(0x02), address(0x03));
    }

    function testRedeemFails() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.redeem(1, address(0x02), address(0x03));
    }

    function testFuzzRedeem(bool shouldThrow, address receiver, address owner, uint256 amount) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.redeem(amount, receiver, owner);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC4626.Redeem(address(handler), receiver, owner, amount);

            handler.redeem(amount, receiver, owner);
        }
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

    function testEq() public pure {
        assertTrue(ERC4626.wrap(address(1)) == ERC4626.wrap(address(1)));

        assertFalse(ERC4626.wrap(address(1)) == ERC4626.wrap(address(2)));
    }

    function testFuzzEq(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) == ERC4626.unwrap(b)) {
            assertTrue(a == b);
        } else {
            assertFalse(a == b);
        }
    }

    function testNeq() public pure {
        assertTrue(ERC4626.wrap(address(1)) != ERC4626.wrap(address(2)));

        assertFalse(ERC4626.wrap(address(1)) != ERC4626.wrap(address(1)));
    }

    function testFuzzNeq(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) != ERC4626.unwrap(b)) {
            assertTrue(a != b);
        } else {
            assertFalse(a != b);
        }
    }

    function testGt() public pure {
        assertTrue(ERC4626.wrap(address(2)) > ERC4626.wrap(address(1)));

        assertFalse(ERC4626.wrap(address(1)) > ERC4626.wrap(address(2)));
    }

    function testFuzzGt(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) > ERC4626.unwrap(b)) {
            assertTrue(a > b);
        } else {
            assertFalse(a > b);
        }
    }

    function testGte() public pure {
        assertTrue(ERC4626.wrap(address(2)) >= ERC4626.wrap(address(1)));

        assertFalse(ERC4626.wrap(address(1)) >= ERC4626.wrap(address(2)));

        assertTrue(ERC4626.wrap(address(1)) >= ERC4626.wrap(address(1)));
    }

    function testFuzzGte(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) >= ERC4626.unwrap(b)) {
            assertTrue(a >= b);
        } else {
            assertFalse(a >= b);
        }
    }

    function testLt() public pure {
        assertTrue(ERC4626.wrap(address(1)) < ERC4626.wrap(address(2)));

        assertFalse(ERC4626.wrap(address(2)) < ERC4626.wrap(address(1)));
    }

    function testFuzzLt(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) < ERC4626.unwrap(b)) {
            assertTrue(a < b);
        } else {
            assertFalse(a < b);
        }
    }

    function testLte() public pure {
        assertTrue(ERC4626.wrap(address(1)) <= ERC4626.wrap(address(2)));

        assertFalse(ERC4626.wrap(address(2)) <= ERC4626.wrap(address(1)));

        assertTrue(ERC4626.wrap(address(1)) <= ERC4626.wrap(address(1)));
    }

    function testFuzzLte(ERC4626 a, ERC4626 b) public pure {
        if (ERC4626.unwrap(a) <= ERC4626.unwrap(b)) {
            assertTrue(a <= b);
        } else {
            assertFalse(a <= b);
        }
    }

    function testAdd() public pure {
        assertTrue(ERC4626.wrap(address(1)) + ERC4626.wrap(address(2)) == ERC4626.wrap(address(3)));
    }

    function testAddOverflow() public {
        vm.expectRevert();
        ERC4626.wrap(address(type(uint160).max)) + ERC4626.wrap(address(1));
    }

    function testFuzzAdd(ERC4626 a, ERC4626 b, ERC4626 c) public {
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
        assertTrue(ERC4626.wrap(address(3)) - ERC4626.wrap(address(2)) == ERC4626.wrap(address(1)));
    }

    function testSubUnderflow() public {
        vm.expectRevert();
        ERC4626.wrap(address(1)) - ERC4626.wrap(address(2));
    }

    function testFuzzSub(ERC4626 a, ERC4626 b, ERC4626 c) public {
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
        assertTrue(ERC4626.wrap(address(2)) * ERC4626.wrap(address(3)) == ERC4626.wrap(address(6)));
    }

    function testMulOverflow() public {
        vm.expectRevert();
        ERC4626.wrap(address(type(uint160).max)) * ERC4626.wrap(address(2));
    }

    function testFuzzMul(ERC4626 a, ERC4626 b, ERC4626 c) public {
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
        assertTrue(ERC4626.wrap(address(6)) / ERC4626.wrap(address(3)) == ERC4626.wrap(address(2)));
    }

    function testDivByZero() public {
        vm.expectRevert();
        ERC4626.wrap(address(1)) / ERC4626.wrap(address(0));
    }

    function testFuzzDiv(ERC4626 a, ERC4626 b, ERC4626 c) public {
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
        assertTrue(ERC4626.wrap(address(6)) % ERC4626.wrap(address(4)) == ERC4626.wrap(address(2)));
    }

    function testModByZero() public {
        vm.expectRevert();
        ERC4626.wrap(address(1)) % ERC4626.wrap(address(0));
    }

    function testFuzzMod(ERC4626 a, ERC4626 b, ERC4626 c) public {
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
        assertTrue(ERC4626.wrap(address(0x03)) & ERC4626.wrap(address(0x02)) == ERC4626.wrap(address(0x02)));
    }

    function testFuzzAnd(ERC4626 a, ERC4626 b, ERC4626 c) public pure {
        if (asU160(a) & asU160(b) == asU160(c)) {
            assertTrue(a & b == c);
        } else {
            assertFalse(a & b == c);
        }
    }

    function testOr() public pure {
        assertTrue(ERC4626.wrap(address(0x03)) | ERC4626.wrap(address(0x02)) == ERC4626.wrap(address(0x03)));
    }

    function testFuzzOr(ERC4626 a, ERC4626 b, ERC4626 c) public pure {
        if (asU160(a) | asU160(b) == asU160(c)) {
            assertTrue(a | b == c);
        } else {
            assertFalse(a | b == c);
        }
    }

    function testXor() public pure {
        assertTrue(ERC4626.wrap(address(0x03)) ^ ERC4626.wrap(address(0x02)) == ERC4626.wrap(address(0x01)));
    }

    function testFuzzXor(ERC4626 a, ERC4626 b, ERC4626 c) public pure {
        if (asU160(a) ^ asU160(b) == asU160(c)) {
            assertTrue(a ^ b == c);
        } else {
            assertFalse(a ^ b == c);
        }
    }

    function testNot() public pure {
        assertTrue(~ERC4626.wrap(address(0x03)) == ERC4626.wrap(address(0xFfFfFfFFfFFFFfffffFfFfFffffffFFfFFFfFFfc)));
    }

    function testFuzzNot(ERC4626 a) public pure {
        uint160 inverse = ~asU160(a);

        assertTrue(~a == ERC4626.wrap(address(inverse)));
    }

    function asU160(ERC4626 a) public pure returns (uint160) {
        return uint160(ERC4626.unwrap(a));
    }
}

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC721 } from "../src/ERC721.sol";
import { MockERC721 } from "./mock/MockERC721.sol";
import { ERC721Handler } from "./handler/ERC721Handler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC721Test is Test {
    MockERC721 internal mock;
    ERC721Handler internal handler;

    function setUp() public {
        mock = new MockERC721();
        handler = new ERC721Handler(address(mock));
    }

    function testSupportsInterface() public {
        mock.setSupportsInterface(0xffffffff, true);
        assertTrue(handler.supportsInterface(0xffffffff));
    }

    function testSupportsInterfaceThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.supportsInterface(0xffffffff);
    }

    function testFuzzSupportsInterface(bool shouldThrow, bytes4 interfaceId, bool supportsInterface) public {
        mock.setShouldThrow(shouldThrow);
        mock.setSupportsInterface(interfaceId, supportsInterface);
        if (shouldThrow) {
            vm.expectRevert();
            handler.supportsInterface(interfaceId);
        } else {
            assertEq(handler.supportsInterface(interfaceId), supportsInterface);
        }
    }

    function testGetApproved() public {
        mock.setApproved(1, address(2));
        assertEq(handler.getApproved(1), address(2));
    }

    function testGetApprovedThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.getApproved(1);
    }

    function testFuzzGetApproved(bool shouldThrow, uint256 tokenId, address approved) public {
        mock.setShouldThrow(shouldThrow);
        mock.setApproved(tokenId, approved);
        if (shouldThrow) {
            vm.expectRevert();
            handler.getApproved(tokenId);
        } else {
            assertEq(handler.getApproved(tokenId), approved);
        }
    }

    function testIsApprovedForAll() public {
        mock.setIsApprovedForAll(address(1), address(2), true);
        assertTrue(handler.isApprovedForAll(address(1), address(2)));
    }

    function testIsApprovedForAllThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.isApprovedForAll(address(1), address(2));
    }

    function testFuzzIsApprovedForAll(bool shouldThrow, address owner, address operator, bool approved) public {
        mock.setShouldThrow(shouldThrow);
        mock.setIsApprovedForAll(owner, operator, approved);
        if (shouldThrow) {
            vm.expectRevert();
            handler.isApprovedForAll(owner, operator);
        } else {
            assertEq(handler.isApprovedForAll(owner, operator), approved);
        }
    }

    function testBalanceOf() public {
        mock.setBalanceOf(address(1), 10);
        assertEq(handler.balanceOf(address(1)), 10);
    }

    function testBalanceOfThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.balanceOf(address(1));
    }

    function testFuzzBalanceOf(bool shouldThrow, address owner, uint256 balance) public {
        mock.setShouldThrow(shouldThrow);
        mock.setBalanceOf(owner, balance);
        if (shouldThrow) {
            vm.expectRevert();
            handler.balanceOf(owner);
        } else {
            assertEq(handler.balanceOf(owner), balance);
        }
    }

    function testOwnerOf() public {
        mock.setOwnerOf(1, address(2));
        assertEq(handler.ownerOf(1), address(2));
    }

    function testOwnerOfThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.ownerOf(1);
    }

    function testFuzzOwnerOf(bool shouldThrow, uint256 tokenId, address owner) public {
        mock.setShouldThrow(shouldThrow);
        mock.setOwnerOf(tokenId, owner);
        if (shouldThrow) {
            vm.expectRevert();
            handler.ownerOf(tokenId);
        } else {
            assertEq(handler.ownerOf(tokenId), owner);
        }
    }

    function testSafeTransferFromWithData() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721.TransferWithData(address(1), address(2), 3, hex"aabbccdd");

        handler.safeTransferFrom(address(1), address(2), 3, hex"aabbccdd");
    }

    function testSafeTransferFromNoData() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721.Transfer(address(1), address(2), 3);

        handler.safeTransferFrom(address(1), address(2), 3);
    }

    function testSafeTransferFromWithDataThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.safeTransferFrom(address(1), address(2), 3, hex"aabbccdd");
    }

    function testSafeTransferFromNoDataThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.safeTransferFrom(address(1), address(2), 3);
    }

    function testFuzzSafeTransferFrom(
        bool shouldThrow,
        bool withData,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.safeTransferFrom(from, to, tokenId, data);
        } else {
            if (withData && data.length > 0) {
                vm.expectEmit(true, true, true, true, address(mock));
                emit MockERC721.TransferWithData(from, to, tokenId, data);
            } else {
                data = new bytes(0);

                vm.expectEmit(true, true, true, true, address(mock));
                emit MockERC721.Transfer(from, to, tokenId);
            }
            handler.safeTransferFrom(from, to, tokenId, data);
        }
    }

    function testTransferFrom() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721.Transfer(address(1), address(2), 3);

        handler.transferFrom(address(1), address(2), 3);
    }

    function testTransferFromThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.transferFrom(address(1), address(2), 3);
    }

    function testFuzzTransferFrom(bool shouldThrow, address from, address to, uint256 tokenId) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.transferFrom(from, to, tokenId);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC721.Transfer(from, to, tokenId);

            handler.transferFrom(from, to, tokenId);
        }
    }

    function testApprove() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721.Approval(address(handler), address(2), 3);

        handler.approve(address(2), 3);
    }

    function testApproveThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.approve(address(2), 3);
    }

    function testFuzzApprove(bool shouldThrow, address spender, uint256 tokenId) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.approve(spender, tokenId);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC721.Approval(address(handler), spender, tokenId);

            handler.approve(spender, tokenId);
        }
    }

    function testSetApprovalForAll() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721.ApprovalForAll(address(handler), address(2), true);

        handler.setApprovalForAll(address(2), true);
    }

    function testSetApprovalForAllThrows() public {
        mock.setShouldThrow(true);
        vm.expectRevert();
        handler.setApprovalForAll(address(2), true);
    }

    function testFuzzSetApprovalForAll(bool shouldThrow, address operator, bool approved) public {
        mock.setShouldThrow(shouldThrow);
        if (shouldThrow) {
            vm.expectRevert();
            handler.setApprovalForAll(operator, approved);
        } else {
            vm.expectEmit(true, true, true, true, address(mock));
            emit MockERC721.ApprovalForAll(address(handler), operator, approved);

            handler.setApprovalForAll(operator, approved);
        }
    }

    function testEq() public pure {
        assertTrue(ERC721.wrap(address(1)) == ERC721.wrap(address(1)));

        assertFalse(ERC721.wrap(address(1)) == ERC721.wrap(address(2)));
    }

    function testFuzzEq(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) == ERC721.unwrap(b)) {
            assertTrue(a == b);
        } else {
            assertFalse(a == b);
        }
    }

    function testNeq() public pure {
        assertTrue(ERC721.wrap(address(1)) != ERC721.wrap(address(2)));

        assertFalse(ERC721.wrap(address(1)) != ERC721.wrap(address(1)));
    }

    function testFuzzNeq(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) != ERC721.unwrap(b)) {
            assertTrue(a != b);
        } else {
            assertFalse(a != b);
        }
    }

    function testGt() public pure {
        assertTrue(ERC721.wrap(address(2)) > ERC721.wrap(address(1)));

        assertFalse(ERC721.wrap(address(1)) > ERC721.wrap(address(2)));
    }

    function testFuzzGt(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) > ERC721.unwrap(b)) {
            assertTrue(a > b);
        } else {
            assertFalse(a > b);
        }
    }

    function testGte() public pure {
        assertTrue(ERC721.wrap(address(2)) >= ERC721.wrap(address(1)));

        assertFalse(ERC721.wrap(address(1)) >= ERC721.wrap(address(2)));

        assertTrue(ERC721.wrap(address(1)) >= ERC721.wrap(address(1)));
    }

    function testFuzzGte(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) >= ERC721.unwrap(b)) {
            assertTrue(a >= b);
        } else {
            assertFalse(a >= b);
        }
    }

    function testLt() public pure {
        assertTrue(ERC721.wrap(address(1)) < ERC721.wrap(address(2)));

        assertFalse(ERC721.wrap(address(2)) < ERC721.wrap(address(1)));
    }

    function testFuzzLt(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) < ERC721.unwrap(b)) {
            assertTrue(a < b);
        } else {
            assertFalse(a < b);
        }
    }

    function testLte() public pure {
        assertTrue(ERC721.wrap(address(1)) <= ERC721.wrap(address(2)));

        assertFalse(ERC721.wrap(address(2)) <= ERC721.wrap(address(1)));

        assertTrue(ERC721.wrap(address(1)) <= ERC721.wrap(address(1)));
    }

    function testFuzzLte(ERC721 a, ERC721 b) public pure {
        if (ERC721.unwrap(a) <= ERC721.unwrap(b)) {
            assertTrue(a <= b);
        } else {
            assertFalse(a <= b);
        }
    }

    function testAdd() public pure {
        assertTrue(ERC721.wrap(address(1)) + ERC721.wrap(address(2)) == ERC721.wrap(address(3)));
    }

    function testAddOverflow() public {
        vm.expectRevert();
        ERC721.wrap(address(type(uint160).max)) + ERC721.wrap(address(1));
    }

    function testFuzzAdd(ERC721 a, ERC721 b, ERC721 c) public {
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
        assertTrue(ERC721.wrap(address(3)) - ERC721.wrap(address(2)) == ERC721.wrap(address(1)));
    }

    function testSubUnderflow() public {
        vm.expectRevert();
        ERC721.wrap(address(1)) - ERC721.wrap(address(2));
    }

    function testFuzzSub(ERC721 a, ERC721 b, ERC721 c) public {
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
        assertTrue(ERC721.wrap(address(2)) * ERC721.wrap(address(3)) == ERC721.wrap(address(6)));
    }

    function testMulOverflow() public {
        vm.expectRevert();
        ERC721.wrap(address(type(uint160).max)) * ERC721.wrap(address(2));
    }

    function testFuzzMul(ERC721 a, ERC721 b, ERC721 c) public {
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
        assertTrue(ERC721.wrap(address(6)) / ERC721.wrap(address(3)) == ERC721.wrap(address(2)));
    }

    function testDivByZero() public {
        vm.expectRevert();
        ERC721.wrap(address(1)) / ERC721.wrap(address(0));
    }

    function testFuzzDiv(ERC721 a, ERC721 b, ERC721 c) public {
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
        assertTrue(ERC721.wrap(address(6)) % ERC721.wrap(address(4)) == ERC721.wrap(address(2)));
    }

    function testModByZero() public {
        vm.expectRevert();
        ERC721.wrap(address(1)) % ERC721.wrap(address(0));
    }

    function testFuzzMod(ERC721 a, ERC721 b, ERC721 c) public {
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
        assertTrue(ERC721.wrap(address(0x03)) & ERC721.wrap(address(0x02)) == ERC721.wrap(address(0x02)));
    }

    function testFuzzAnd(ERC721 a, ERC721 b, ERC721 c) public pure {
        if (asU160(a) & asU160(b) == asU160(c)) {
            assertTrue(a & b == c);
        } else {
            assertFalse(a & b == c);
        }
    }

    function testOr() public pure {
        assertTrue(ERC721.wrap(address(0x03)) | ERC721.wrap(address(0x02)) == ERC721.wrap(address(0x03)));
    }

    function testFuzzOr(ERC721 a, ERC721 b, ERC721 c) public pure {
        if (asU160(a) | asU160(b) == asU160(c)) {
            assertTrue(a | b == c);
        } else {
            assertFalse(a | b == c);
        }
    }

    function testXor() public pure {
        assertTrue(ERC721.wrap(address(0x03)) ^ ERC721.wrap(address(0x02)) == ERC721.wrap(address(0x01)));
    }

    function testFuzzXor(ERC721 a, ERC721 b, ERC721 c) public pure {
        if (asU160(a) ^ asU160(b) == asU160(c)) {
            assertTrue(a ^ b == c);
        } else {
            assertFalse(a ^ b == c);
        }
    }

    function testNot() public pure {
        assertTrue(~ERC721.wrap(address(0x03)) == ERC721.wrap(address(0xFfFfFfFFfFFFFfffffFfFfFffffffFFfFFFfFFfc)));
    }

    function testFuzzNot(ERC721 a) public pure {
        uint160 inverse = ~asU160(a);

        assertTrue(~a == ERC721.wrap(address(inverse)));
    }

    function asU160(ERC721 a) public pure returns (uint160) {
        return uint160(ERC721.unwrap(a));
    }
}

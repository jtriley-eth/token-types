// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC721Receiver } from "../src/receivers//ERC721Receiver.sol";
import { MockERC721Receiver } from "./mock/MockERC721Receiver.sol";
import { ERC721ReceiverHandler } from "./handler/ERC721ReceiverHandler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC721ReceiverTest is Test {
    MockERC721Receiver internal mock;
    ERC721ReceiverHandler internal handler;

    function setUp() public {
        mock = new MockERC721Receiver();
        handler = new ERC721ReceiverHandler(address(mock));
    }

    function testERC721Received() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721Receiver.Received(address(1), address(2), 3, new bytes(0));

        handler.onERC721Received(address(1), address(2), 3);
    }

    function testERC721ReceivedReverts() public {
        mock.setShouldThrow(true);

        vm.expectRevert();
        handler.onERC721Received(address(1), address(2), 3);
    }

    function testERC721ReceivedInvalidReturn() public {
        mock.setReturnValue(0xaabbccdd);

        vm.expectRevert();
        handler.onERC721Received(address(1), address(2), 3);
    }

    function testERC721ReceivedWithData() public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit MockERC721Receiver.Received(address(1), address(2), 3, hex"aabbccdd");

        handler.onERC721Received(address(1), address(2), 3, hex"aabbccdd");
    }

    function testERC721ReceivedWithDataReverts() public {
        mock.setShouldThrow(true);

        vm.expectRevert();
        handler.onERC721Received(address(1), address(2), 3, hex"aabbccdd");
    }

    function testERC721ReceivedWithDataInvalidReturn() public {
        mock.setReturnValue(0xaabbccdd);

        vm.expectRevert();
        handler.onERC721Received(address(1), address(2), 3, hex"aabbccdd");
    }

    function testFuzzERC721Received(
        bool shouldThrow,
        bool validReturn,
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public {
        mock.setShouldThrow(shouldThrow);
        mock.setReturnValue(validReturn ? MockERC721Receiver.onERC721Received.selector : bytes4(0xaabbccdd));

        if (data.length == 0) {
            if (shouldThrow || !validReturn) {
                vm.expectRevert();
                handler.onERC721Received(operator, from, tokenId);
            } else {
                vm.expectEmit(true, true, true, true, address(mock));
                emit MockERC721Receiver.Received(operator, from, tokenId, data);

                handler.onERC721Received(operator, from, tokenId);
            }
        } else {
            if (shouldThrow || !validReturn) {
                vm.expectRevert();
                handler.onERC721Received(operator, from, tokenId, data);
            } else {
                vm.expectEmit(true, true, true, true, address(mock));
                emit MockERC721Receiver.Received(operator, from, tokenId, data);

                handler.onERC721Received(operator, from, tokenId, data);
            }
        }
    }

    function testEq() public pure {
        assertTrue(ERC721Receiver.wrap(address(1)) == ERC721Receiver.wrap(address(1)));

        assertFalse(ERC721Receiver.wrap(address(1)) == ERC721Receiver.wrap(address(2)));
    }

    function testFuzzEq(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) == ERC721Receiver.unwrap(b)) {
            assertTrue(a == b);
        } else {
            assertFalse(a == b);
        }
    }

    function testNeq() public pure {
        assertTrue(ERC721Receiver.wrap(address(1)) != ERC721Receiver.wrap(address(2)));

        assertFalse(ERC721Receiver.wrap(address(1)) != ERC721Receiver.wrap(address(1)));
    }

    function testFuzzNeq(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) != ERC721Receiver.unwrap(b)) {
            assertTrue(a != b);
        } else {
            assertFalse(a != b);
        }
    }

    function testGt() public pure {
        assertTrue(ERC721Receiver.wrap(address(2)) > ERC721Receiver.wrap(address(1)));

        assertFalse(ERC721Receiver.wrap(address(1)) > ERC721Receiver.wrap(address(2)));
    }

    function testFuzzGt(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) > ERC721Receiver.unwrap(b)) {
            assertTrue(a > b);
        } else {
            assertFalse(a > b);
        }
    }

    function testGte() public pure {
        assertTrue(ERC721Receiver.wrap(address(2)) >= ERC721Receiver.wrap(address(1)));

        assertFalse(ERC721Receiver.wrap(address(1)) >= ERC721Receiver.wrap(address(2)));

        assertTrue(ERC721Receiver.wrap(address(1)) >= ERC721Receiver.wrap(address(1)));
    }

    function testFuzzGte(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) >= ERC721Receiver.unwrap(b)) {
            assertTrue(a >= b);
        } else {
            assertFalse(a >= b);
        }
    }

    function testLt() public pure {
        assertTrue(ERC721Receiver.wrap(address(1)) < ERC721Receiver.wrap(address(2)));

        assertFalse(ERC721Receiver.wrap(address(2)) < ERC721Receiver.wrap(address(1)));
    }

    function testFuzzLt(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) < ERC721Receiver.unwrap(b)) {
            assertTrue(a < b);
        } else {
            assertFalse(a < b);
        }
    }

    function testLte() public pure {
        assertTrue(ERC721Receiver.wrap(address(1)) <= ERC721Receiver.wrap(address(2)));

        assertFalse(ERC721Receiver.wrap(address(2)) <= ERC721Receiver.wrap(address(1)));

        assertTrue(ERC721Receiver.wrap(address(1)) <= ERC721Receiver.wrap(address(1)));
    }

    function testFuzzLte(ERC721Receiver a, ERC721Receiver b) public pure {
        if (ERC721Receiver.unwrap(a) <= ERC721Receiver.unwrap(b)) {
            assertTrue(a <= b);
        } else {
            assertFalse(a <= b);
        }
    }

    function testAdd() public pure {
        assertTrue(ERC721Receiver.wrap(address(1)) + ERC721Receiver.wrap(address(2)) == ERC721Receiver.wrap(address(3)));
    }

    function testAddOverflow() public {
        vm.expectRevert();
        ERC721Receiver.wrap(address(type(uint160).max)) + ERC721Receiver.wrap(address(1));
    }

    function testFuzzAdd(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public {
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
        assertTrue(ERC721Receiver.wrap(address(3)) - ERC721Receiver.wrap(address(2)) == ERC721Receiver.wrap(address(1)));
    }

    function testSubUnderflow() public {
        vm.expectRevert();
        ERC721Receiver.wrap(address(1)) - ERC721Receiver.wrap(address(2));
    }

    function testFuzzSub(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public {
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
        assertTrue(ERC721Receiver.wrap(address(2)) * ERC721Receiver.wrap(address(3)) == ERC721Receiver.wrap(address(6)));
    }

    function testMulOverflow() public {
        vm.expectRevert();
        ERC721Receiver.wrap(address(type(uint160).max)) * ERC721Receiver.wrap(address(2));
    }

    function testFuzzMul(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public {
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
        assertTrue(ERC721Receiver.wrap(address(6)) / ERC721Receiver.wrap(address(3)) == ERC721Receiver.wrap(address(2)));
    }

    function testDivByZero() public {
        vm.expectRevert();
        ERC721Receiver.wrap(address(1)) / ERC721Receiver.wrap(address(0));
    }

    function testFuzzDiv(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public {
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
        assertTrue(ERC721Receiver.wrap(address(6)) % ERC721Receiver.wrap(address(4)) == ERC721Receiver.wrap(address(2)));
    }

    function testModByZero() public {
        vm.expectRevert();
        ERC721Receiver.wrap(address(1)) % ERC721Receiver.wrap(address(0));
    }

    function testFuzzMod(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public {
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
        assertTrue(
            ERC721Receiver.wrap(address(0x03)) & ERC721Receiver.wrap(address(0x02))
                == ERC721Receiver.wrap(address(0x02))
        );
    }

    function testFuzzAnd(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public pure {
        if (asU160(a) & asU160(b) == asU160(c)) {
            assertTrue(a & b == c);
        } else {
            assertFalse(a & b == c);
        }
    }

    function testOr() public pure {
        assertTrue(
            ERC721Receiver.wrap(address(0x03)) | ERC721Receiver.wrap(address(0x02))
                == ERC721Receiver.wrap(address(0x03))
        );
    }

    function testFuzzOr(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public pure {
        if (asU160(a) | asU160(b) == asU160(c)) {
            assertTrue(a | b == c);
        } else {
            assertFalse(a | b == c);
        }
    }

    function testXor() public pure {
        assertTrue(
            ERC721Receiver.wrap(address(0x03)) ^ ERC721Receiver.wrap(address(0x02))
                == ERC721Receiver.wrap(address(0x01))
        );
    }

    function testFuzzXor(ERC721Receiver a, ERC721Receiver b, ERC721Receiver c) public pure {
        if (asU160(a) ^ asU160(b) == asU160(c)) {
            assertTrue(a ^ b == c);
        } else {
            assertFalse(a ^ b == c);
        }
    }

    function testNot() public pure {
        assertTrue(
            ~ERC721Receiver.wrap(address(0x03))
                == ERC721Receiver.wrap(address(0xFfFfFfFFfFFFFfffffFfFfFffffffFFfFFFfFFfc))
        );
    }

    function testFuzzNot(ERC721Receiver a) public pure {
        uint160 inverse = ~asU160(a);

        assertTrue(~a == ERC721Receiver.wrap(address(inverse)));
    }

    function asU160(ERC721Receiver a) public pure returns (uint160) {
        return uint160(ERC721Receiver.unwrap(a));
    }
}

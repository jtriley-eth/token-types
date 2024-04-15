// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC165 } from "../src/ERC165.sol";
import { MockERC165 } from "./mock/MockERC165.sol";
import { ERC165Handler } from "./handler/ERC165Handler.sol";

import { Test } from "../lib/forge-std/src/Test.sol";

contract ERC165Test is Test {
    MockERC165 internal mock;
    ERC165Handler internal handler;

    function setUp() public {
        mock = new MockERC165();
        handler = new ERC165Handler(address(mock));
    }

    function testSupportsInterface() public {
        assertFalse(handler.supportsInterface(0xaabbccdd));
        mock.setSupportsInterface(0xaabbccdd, true);
        assertTrue(handler.supportsInterface(0xaabbccdd));
    }

    function testSupportsInterfaceReverts() public {
        mock.setShouldThrow(true);

        vm.expectRevert();
        handler.supportsInterface(0xaabbccdd);
    }

    function testSupportsInterfaceReturnsNothing() public {
        mock.setShouldReturnAnything(false);

        vm.expectRevert();
        handler.supportsInterface(0xaabbccdd);
    }

    function testFuzzSupportsInterface(
        bool throws,
        bool shouldReturnAnything,
        bytes4 interfaceId,
        bool supported
    ) external {
        mock.setShouldThrow(throws);
        mock.setShouldReturnAnything(shouldReturnAnything);
        mock.setSupportsInterface(interfaceId, supported);

        if (throws || !shouldReturnAnything) {
            vm.expectRevert();
            handler.supportsInterface(interfaceId);
        } else {
            assertEq(supported, handler.supportsInterface(interfaceId));
        }
    }
}

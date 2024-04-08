// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC721Receiver } from "../../src/receivers/ERC721Receiver.sol";

contract ERC721ReceiverHandler {
    ERC721Receiver immutable receiver;

    constructor(address _receiver) {
        receiver = ERC721Receiver.wrap(_receiver);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId
    ) external {
        receiver.onERC721Received(operator, from, tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external {
        receiver.onERC721ReceivedWithData(operator, from, tokenId, data);
    }
}

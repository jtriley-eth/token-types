// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC721 } from "../../src/ERC721.sol";

contract ERC721Handler {
    ERC721 immutable erc721;

    constructor(address _erc721) {
        erc721 = ERC721.wrap(_erc721);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return erc721.supportsInterface(interfaceId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        return erc721.getApproved(tokenId);
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return erc721.isApprovedForAll(owner, operator);
    }

    function balanceOf(address owner) external view returns (uint256) {
        return erc721.balanceOf(owner);
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        return erc721.ownerOf(tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        erc721.safeTransferFrom(from, to, tokenId, new bytes(0));
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {
        erc721.safeTransferFrom(from, to, tokenId, data);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        erc721.transferFrom(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external {
        erc721.approve(to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) external {
        erc721.setApprovalForAll(operator, approved);
    }
}

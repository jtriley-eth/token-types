// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.25;

import { ERC165 } from "../../src/ERC165.sol";

contract ERC165Handler {
    ERC165 immutable erc165;

    constructor(address _erc165) {
        erc165 = ERC165.wrap(_erc165);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return erc165.supportsInterface(interfaceId);
    }
}

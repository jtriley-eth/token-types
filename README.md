## Token Types

Interfaces are expensive. They allocate new memory on each call regardless of whether the encoded
data is reused or not.

"Safe" transfer libraries are a patch and handle the influential companies that couldn't be bothered
to actually conform to the ERC20 specification, but they're still clunky and applying functions to
interfaces that have independent functionality clutters the namespace and makes code harder to read,
and we collectively spend far longer reading code than writing, so we should care about it as devs.

So here's the solution. We define custom types over the `address` primitive. The custom types have
similar names to the contract interface, as well as the functions that would otherwise sit on the
interface, but instead of generating solidity's abi encoding and memory allocations, we instead use
the scratch space to make external calls with no additional memory allocations.

```solidity
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.24;

import { ERC20 } from "token-types/ERC20.sol";

contract Vault {
    mapping(ERC20 => mapping(address => uint256)) public deposits;

    function deposit(ERC20 token, uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        deposits[token][msg.sender] += amount;
        // msize == 0x80
    }

    function withdraw(ERC20 token, uint256 amount) external {
        deposits[token][msg.sender] -= amount;
        token.transfer(msg.sender, amount);
        // msize == 0x80
    }
}
```

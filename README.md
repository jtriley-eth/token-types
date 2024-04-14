## Token Types

### Motivation

Interfaces were a good abstraction for their time, but are outdated. Interface interactions allocate
memory and abstract away important edge cases in smart contract interactions.

"Safe" transfer libraries are a patch, using function-call syntax to create a syntactically similar
interface to external contracts with custom checks, such as the notorious ERC20 noncompliance edge
cases where ERC20 tokens return no data. However, this is a clunky solution, especially in cases
where the library "applies" functions to the same namespace as the core interface. This makes
reasoning about a type's API difficult. We collectively spend far more time reading code than
writing, so we should care about this.

Presented is one solution. We define custom type aliases over the `address` primitive. The custom
types have the same names as the contract interfaces, contain the same functions that would
otherwise exist in the interface's namespace, but instead of generating solidity's enshrined
interface abstractions, we optimize the obvious cases and remove new memory allocations.

There are cases in which memory is expanded, such as dynamically sized values with unknown bounds at
compile time; however, the free memory pointer is never increased, meaning in the rare case where
evm memory is expanded, it can be reused by the solidity compiler.

### Basic Usage

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

### Existing Types

Documentation is prefixed to respective type and function definitions.

- [`ERC20`](src/ERC20.sol)
- [`ERC721`](src/ERC721.sol)
  - [`ERC721Receiver`](src/receivers/ERC721Receiver.sol)
- [`ERC4626`](src/ERC4626.sol)
- [`ERC6909`](src/ERC6909.sol)

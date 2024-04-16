## Token Types

### TL;DR

Token Types are drop-in replacements for interfaces.

All the expected functions, all of the available operators, none of the memory allocation, and none of the bloat.

```solidity
// replace this:
import { IERC20 } from "some-other-project/IERC20.sol";

// with this:
import { ERC20 } from "token-types/ERC20.sol";
```

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

### Behavior

- Each external call asserts:
  - The call succeeded.
  - The call returned the correct returndatasize.
  - If a stateful call returns a boolean to indicate success:
    - The call returned `true`.
  - If the call is ERC20's `transfer`, `transferFrom`, or `approve`:
    - No data was returned OR (the returndata is 32 bytes AND is `true`).
- The operators `+`, `-`, `*`, `/`, and `%` revert if the operation:
  - Overflows.
  - Underflows.
  - Divides by zero.
- The operator `~` masks the address to `160` bits after performing bitwise `not`.

### Existing Types

Documentation is prefixed to respective type and function definitions.

- [`ERC20`](src/ERC20.sol)
- [`ERC721`](src/ERC721.sol)
  - [`ERC721Receiver`](src/receivers/ERC721Receiver.sol)
- [`ERC4626`](src/ERC4626.sol)
- [`ERC6909`](src/ERC6909.sol)

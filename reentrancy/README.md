# Reentrancy Vulnerability Demonstration

## What the Bug Is

A reentrancy vulnerability exists in the `VulnerableBank` contract's `withdraw()` function. This vulnerability allows an attacker to drain all funds from the smart contract by exploiting the order in which operations are executed.

The vulnerable code:

```solidity
function withdraw() external {
    uint256 bal = balances[msg.sender];
    require(bal > 0, "No balance");

    (bool ok, ) = msg.sender.call{value: bal}("");
    require(ok, "ETH transfer failed");

    balances[msg.sender] = 0;
}
```

The critical issue is the placement of the state update (`balances[msg.sender] = 0`). It occurs AFTER the ETH transfer, which invokes the recipient's `receive()` or `fallback()` function. This creates an opportunity for the recipient to re-enter the contract.

## How the Attack Works

The attacker deploys a malicious contract with a `receive()` function that automatically calls `withdraw()` again:

```solidity
receive() external payable {
    if (address(bank).balance >= 1 ether) {
        bank.withdraw();
    }
}
```

Attack sequence:

1. The attacker deposits 1 ETH into the bank, establishing a balance
2. The attacker calls `attack()`, which initiates a withdrawal of 1 ETH
3. The bank sends 1 ETH to the attacker's contract
4. The ETH transfer triggers the attacker's `receive()` function
5. The `receive()` function checks if the bank still has enough balance
6. Since `balances[attacker] = 0` hasn't executed yet, the check passes, and the attacker calls `withdraw()` again
7. The bank processes another withdrawal and sends another 1 ETH
8. This cycle repeats until the bank is completely drained
9. Only then does the original execution chain unwind and state updates occur

The attacker can steal far more ETH than they deposited because the balance updates occur after the external call.

## Why It Happens

The vulnerability exists due to three key issues in the contract design:

1. Incorrect Operation Order: The contract follows the pattern of checking balances, transferring funds, then updating state. This is backwards.

2. Dangerous External Calls: The `call{value: bal}("")` pattern is a low-level call that invokes code on the recipient. If the recipient is a contract with a `receive()` function, that function executes immediately during the call.

3. State Not Updated Before External Calls: The balance update happens after the external call, so when the attacker's `receive()` function calls `withdraw()` again, the balance check still passes because the state hasn't been updated yet.

This is a classic violation of the "Checks-Effects-Interactions" pattern, which prescribes:
- Checks: Validate conditions
- Effects: Update internal state
- Interactions: Make external calls

## How You Fixed It

The vulnerability can be fixed by restructuring the function to follow the Checks-Effects-Interactions pattern:

```solidity
function withdraw() external {
    uint256 bal = balances[msg.sender];
    require(bal > 0, "No balance");

    // Effects: Update state BEFORE external call
    balances[msg.sender] = 0;

    // Interactions: Make external call AFTER state update
    (bool ok, ) = msg.sender.call{value: bal}("");
    require(ok, "ETH transfer failed");
}
```

By updating `balances[msg.sender] = 0` before the external call, any reentrancy attempt will fail because the balance check will find a zero balance on the second call.

Alternative solutions include:

1. Using a Reentrancy Guard (Mutex Pattern):
```solidity
bool private locked;

modifier nonReentrant {
    require(!locked);
    locked = true;
    _;
    locked = false;
}

function withdraw() external nonReentrant {
    // ... original code
}
```

2. Using OpenZeppelin's ReentrancyGuard:
```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SafeBank is ReentrancyGuard {
    function withdraw() external nonReentrant {
        // ... original code
    }
}
```

3. Using Low-Level Transfer Instead of Call:
```solidity
// Less flexible but safer for simple transfers
(bool success, ) = payable(msg.sender).transfer(bal);
require(success, "Transfer failed");
```

The Checks-Effects-Interactions pattern is the most recommended solution as it addresses the root cause and follows best practices for secure smart contract development.

## Testing

The test suite demonstrates the vulnerability:

```shell
forge test
```

The `testReentrancyAttack()` test shows that the attacker can successfully drain the bank, validating the vulnerability before it's patched.

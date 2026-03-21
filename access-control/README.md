# Access Control Vulnerability (Foundry)

## Overview

This project demonstrates a common access control vulnerability in smart contracts and how to fix it using Solidity and Foundry.

It includes:

* A vulnerable contract (`VulnerableAccess.sol`)
* A secure contract (`SecureAccess.sol`)
* Tests that simulate both attack and protection scenarios

---

## What the Bug Is

The vulnerable contract allows any user to change the contract owner:

```solidity
function changeOwner(address newOwner) public {
    owner = newOwner;
}
```

There is no access control, meaning the function can be called by anyone.

---

## How the Attack Works

1. An attacker calls `changeOwner(attackerAddress)`
2. The contract updates the owner without verification
3. The attacker becomes the new owner
4. The attacker can now call restricted functions like `sensitiveAction()`

Example from the test:

```solidity
vm.prank(attacker);
vuln.changeOwner(attacker);
```

---

## Why It Happens

The issue occurs because:

* The function lacks a permission check
* There is no validation such as:

```solidity
require(msg.sender == owner);
```

In smart contracts, every critical function must restrict who can call it.

---

## How It Was Fixed

A modifier is introduced to restrict access:

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

Then applied to sensitive functions:

```solidity
function changeOwner(address newOwner) public onlyOwner {
    require(newOwner != address(0), "Zero address");
    owner = newOwner;
}
```

---

## Tests

The test suite verifies both vulnerable and secure behavior:

* `testExploitVulnerable`
  Demonstrates that an attacker can take ownership

* `testSecureAccessFailsForAttacker`
  Confirms that unauthorized users are blocked

* `testSecureOwnerCanChangeOwner`
  Confirms that the owner can update ownership correctly

---

## Run the Project

```bash
forge build
forge test -vv
```

---

## Project Structure

```
access-control/
├── src/
│   ├── VulnerableAccess.sol
│   ├── SecureAccess.sol
├── test/
│   ├── AccessControl.t.sol
```

---

## Conclusion

This project shows how a missing access control check can lead to a complete contract takeover and how proper authorization mechanisms prevent it.

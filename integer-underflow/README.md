# Integer Underflow Vulnerability (Foundry)

## What the Bug Is

Integer underflow occurs when a number is decreased below its minimum value.
In Solidity, this happens when subtracting a larger number from a smaller one.

For unsigned integers (`uint256`), the minimum value is `0`.
If you subtract `1` from `0`, the value wraps around to the maximum possible value:

```
0 - 1 → 2^256 - 1
```

This produces a very large number instead of throwing an error.

---

## How the Attack Works

1. The contract allows subtraction without proper validation.
2. An attacker calls a function like `withdraw(1)` when the balance is `0`.
3. Due to underflow, the balance becomes a very large number (`2^256 - 1`).
4. The attacker effectively gains an extremely large balance.

### Example Flow:

```
Initial balance = 0
Withdraw 1
→ Underflow occurs
→ New balance = 115792089... (very large number)
```

---

## Why It Happens

There are two main reasons:

### 1. Missing Validation

The contract does not check whether:

```
balance >= amount
```

### 2. Use of `unchecked` or Older Solidity Versions

* In Solidity versions before 0.8.0, underflow and overflow were not automatically checked.
* In Solidity 0.8.0 and later, arithmetic is safe by default.
* However, using:

```solidity
unchecked {
    balance -= amount;
}
```

disables safety checks and allows underflow.

---

## How It Was Fixed

### Fix 1: Add Validation

```solidity
require(balance >= amount, "Insufficient balance");
balance -= amount;
```

This ensures subtraction only happens when it is safe.

---

### Fix 2: Use Solidity ≥ 0.8.0

Modern Solidity automatically prevents underflow and reverts the transaction if it occurs.

---

## Summary

* Bug: Integer underflow due to unsafe subtraction
* Impact: Can give attackers extremely large balances
* Cause: Missing checks or use of `unchecked`
* Fix: Validate inputs and rely on Solidity 0.8+ safety

---

## Test Results

* Vulnerable contract: Underflow occurs and produces a large balance
* Fixed contract: Transaction reverts and prevents the issue

---

This project demonstrates how improper arithmetic handling can lead to critical smart contract vulnerabilities.

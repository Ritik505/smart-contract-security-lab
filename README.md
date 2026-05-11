# Smart Contract Security Lab

A hands-on repository focused on identifying, exploiting, and fixing smart contract vulnerabilities using Solidity and Foundry.

This repo is built as a practical security lab where each vulnerability is:
- Implemented in a vulnerable contract
- Exploited to demonstrate the issue
- Fixed using secure coding practices
- Tested using Foundry

## Repository Structure

smart-contract-security-lab/
├── README.md
├── access-control/
│   ├── README.md
│   ├── src/
│   │   ├── SecureAccess.sol
│   │   └── VulnerableAccess.sol
│   └── test/
│       └── AccessControl.t.sol
├── integer-underflow/
│   ├── README.md
│   ├── src/
│   │   ├── UnderflowFixed.sol
│   │   └── UnderflowVulnerable.sol
│   └── test/
│       └── Underflow.t.sol
└── reentrancy/
├── README.md
├── src/
│   ├── Attacker.sol
│   ├── ReentrancyFixed.sol
│   └── VulnerableBank.sol
└── test/
├── Reentrancy.t.sol
└── ReentrancyFixed.t.sol

---

## Covered Vulnerabilities

### Reentrancy
- Classic reentrancy attack using external calls
- Attacker contract drains funds
- Fixed using:
  - Checks-Effects-Interactions pattern
  - Reentrancy guards

Folder: `/reentrancy`

---

### Access Control Issues
- Missing or improper access restrictions
- Unauthorized users calling privileged functions
- Fixed using:
  - `require(msg.sender == owner)`
  - Role-based access control patterns

Folder: `/access-control`

---

### Integer Overflow / Underflow
- Demonstrates unsafe arithmetic (pre Solidity 0.8 behavior)
- Shows how values wrap around unexpectedly
- Fixed using:
  - Solidity >= 0.8 built-in checks
  - Safe arithmetic practices

Folder: `/integer-underflow`

---

## Testing

All vulnerabilities are tested using Foundry.

Each module includes:
- Exploit test cases (prove vulnerability exists)
- Fix validation tests (prove vulnerability is resolved)

Run tests:

```bash
forge test
```

---

## Tech Stack

- Solidity
- Foundry
- Ethereum Virtual Machine (EVM)

---

## Purpose

This repository is designed to:
- Deepen understanding of smart contract security
- Demonstrate real-world vulnerability exploitation
- Showcase secure development practices
- Serve as a reference for auditing patterns

---

## Disclaimer

This repository is for educational purposes only.  
The vulnerable contracts are intentionally insecure and must not be used in production.

---

## Author

Ritik Verma  
Blockchain Engineer | Smart Contract Security | Web3

Portfolio: https://ritikportfoliodev.netlify.app  
GitHub: https://github.com/Ritik505

---

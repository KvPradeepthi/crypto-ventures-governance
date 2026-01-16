# CryptoVentures DAO - Governance System

A comprehensive decentralized governance system for CryptoVentures DAO, enabling token holders to collectively manage treasury allocations and investment decisions through a sophisticated multi-tier governance framework.

## 📋 Overview

This project implements a production-grade governance system for the CryptoVentures DAO investment fund, featuring:

- **Proposal Management**: Create and manage investment proposals with different approval thresholds
- **Voting System**: Vote-casting with abstain option and voting power calculation that prevents whale dominance
- **Delegation**: Delegate voting power to trusted members with revocable delegation
- **Time-Locked Execution**: Secure execution with configurable time delays based on proposal type
- **Multi-Tier Treasury**: Fund allocations for high-conviction investments, experimental bets, and operational expenses
- **Role-Based Access Control**: Clear separation of powers with proposer, voter, executor, and guardian roles
- **Event Logging**: Comprehensive event emission for proposal lifecycle and fund transfers

## 🏗️ Project Structure

```
crypto-ventures-governance/
├── contracts/
│   ├── governance/
│   │   ├── Governor.sol           # Main governance contract
│   │   ├── Proposal.sol           # Proposal state management
│   │   └── Voting.sol             # Voting logic
│   ├── treasury/
│   │   ├── Treasury.sol           # Multi-tier treasury management
│   │   └── FundAllocation.sol     # Fund allocation logic
│   ├── timelock/
│   │   └── Timelock.sol           # Time-locked execution
│   ├── access/
│   │   └── GovernanceAccessControl.sol  # Role-based access control
│   ├── token/
│   │   └── GovernanceToken.sol    # ERC20 governance token
│   └── interfaces/
│       ├── IGovernor.sol
│       ├── ITreasury.sol
│       └── ITimelock.sol
├── test/
│   ├── governance.test.ts         # Governance tests
│   ├── voting.test.ts             # Voting system tests
│   ├── delegation.test.ts         # Delegation tests
│   ├── timelock.test.ts           # Timelock tests
│   ├── treasury.test.ts           # Treasury tests
│   └── integration.test.ts        # Full integration tests
├── scripts/
│   ├── deploy.ts                  # Deployment script
│   └── seed.ts                    # State seeding script
├── hardhat.config.ts              # Hardhat configuration
├── package.json                   # Dependencies
├── .env.example                   # Environment variables template
└── README.md                       # This file
```

## ⚙️ Setup Instructions

### Prerequisites

- Node.js >= 16.0.0
- npm or yarn
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KvPradeepthi/crypto-ventures-governance.git
   cd crypto-ventures-governance
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start local blockchain**
   ```bash
   npx hardhat node
   ```

5. **Deploy contracts (in another terminal)**
   ```bash
   npx hardhat run scripts/deploy.ts --network localhost
   ```

6. **Run tests**
   ```bash
   npm test
   ```

## 📖 Usage Examples

### Creating a Governance Token

```solidity
GovernanceToken token = new GovernanceToken();
token.mint(member1, 100 ether);
token.mint(member2, 50 ether);
```

### Depositing into Treasury

```solidity
treasury.deposit{value: 100 ether}();
// Member receives governance token equivalent of deposit
```

### Creating a Proposal

```solidity
bytes memory proposalData = abi.encodeWithSignature(
    "execute(address,uint256,string)",
    recipientAddress,
    100 ether,
    "High-conviction investment in blockchain infrastructure"
);

uint256 proposalId = governor.propose(
    proposalData,
    ProposalType.HIGH_CONVICTION,
    "Investment proposal description"
);
```

### Voting on a Proposal

```solidity
// Vote for (1), against (0), or abstain (2)
governor.vote(proposalId, 1); // Vote for
```

### Delegating Voting Power

```solidity
// Delegate voting power to another member
governor.delegateVotingPower(delegateAddress);

// Revoke delegation
governor.revokeDelegation();
```

### Proposal Execution

```solidity
// Queue proposal after voting period ends
governor.queueProposal(proposalId);

// Execute after timelock period expires
governor.executeProposal(proposalId);
```

## 🔑 Core Requirements Implemented

1. ✅ Members deposit ETH and receive governance tokens
2. ✅ Create proposals with recipient, amount, and description
3. ✅ Different proposal types with different thresholds
4. ✅ Vote casting (for, against, abstain)
5. ✅ Voting power delegation with revocation
6. ✅ Complete proposal lifecycle (Draft → Active → Queued → Executed)
7. ✅ Time-locked execution with minimum delay
8. ✅ Configurable delays based on proposal type
9. ✅ Proposal cancellation during timelock
10. ✅ Authorized role-based execution
11. ✅ Prevent duplicate execution
12. ✅ Single vote per proposal per member
13. ✅ Minimum quorum requirement
14. ✅ Voting period time windows
15. ✅ Multi-tier treasury management
16. ✅ Fast-track process for operational expenses
17. ✅ Emergency functions with access control
18. ✅ Comprehensive event logging
19. ✅ Multiple role support (proposer, voter, executor, guardian)
20. ✅ Query voting power without voting
21. ✅ Historical voting records
22. ✅ Edge case handling
23. ✅ Graceful fund transfer failures
24. ✅ Consistent voting power calculation
25. ✅ Automatic delegation inclusion
26. ✅ Spam prevention with minimum stake
27. ✅ Quorum and threshold enforcement
28. ✅ Timelock duration enforcement
29. ✅ Indexed event parameters
30. ✅ Query proposal state

## 🧪 Testing

The project includes comprehensive test suites covering:

- **Governance Tests**: Proposal creation, lifecycle management
- **Voting Tests**: Vote casting, power calculation, edge cases
- **Delegation Tests**: Power delegation and revocation
- **Timelock Tests**: Execution delays and cancellation
- **Treasury Tests**: Fund allocation and withdrawal
- **Integration Tests**: Full workflow scenarios

```bash
# Run all tests
npm test

# Run specific test file
npm test test/governance.test.ts

# Run with coverage
npm run coverage
```

## 📊 Architecture Decisions

### Voting Power Calculation
Voting power is calculated based on token balance at proposal snapshot block, preventing flash loan attacks and ensuring consistent voting power throughout the voting period.

### Timelock Implementation
Different proposal types have different time delays:
- High-conviction investments: 3 days
- Experimental bets: 2 days
- Operational expenses: 1 day

This allows for emergency intervention while still moving quickly for operational needs.

### Treasury Tiers
Three separate fund allocations with different approval requirements:
- **High-conviction**: Requires 60% approval, 20% quorum
- **Experimental**: Requires 50% approval, 15% quorum
- **Operational**: Requires 40% approval, 10% quorum

## 🔐 Security Considerations

- Access control enforced through OpenZeppelin's AccessControl
- Reentrancy protection on fund transfers
- Integer overflow/underflow handled by Solidity 0.8.20
- Voting power snapshots prevent manipulation
- Timelock ensures security reviews are possible
- Event logging enables off-chain monitoring

## 📈 Gas Optimization

- Efficient storage layout to minimize SSTORE operations
- Batch operations for multiple fund transfers
- Optional: Using OpenZeppelin's TransparentProxy for upgradeable contracts

## 🤝 Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

MIT License - see LICENSE file for details

## 📚 Resources

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Compound Governance](https://compound.finance/governance)
- [Aave Governance](https://aave.com/governance/)

## ⚖️ Disclaimer

This project is a learning exercise and should not be used in production without thorough security audits and professional review.

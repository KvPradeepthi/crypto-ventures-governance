// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title GovernanceToken
/// @dev ERC20 governance token with voting power tracking for DAO governance
contract GovernanceToken is ERC20, ERC20Votes, ERC20Permit, Ownable {
    /// @notice Maximum supply of governance tokens
    uint256 public constant MAX_SUPPLY = 10000000 ether;

    /// @notice Initial balance for members
    mapping(address => uint256) public deposits;

    /// @notice Event emitted when a member deposits ETH
    event Deposit(address indexed member, uint256 amount, uint256 tokensReceived);

    /// @notice Event emitted when a member withdraws
    event Withdrawal(address indexed member, uint256 amount);

    constructor() 
        ERC20("CryptoVentures Governance Token", "CVG") 
        ERC20Permit("CryptoVentures Governance Token") 
    {}

    /// @notice Members deposit ETH to receive governance tokens
    /// @dev Mints 1 token per wei deposited
    receive() external payable {
        require(msg.value > 0, "Must deposit ETH");
        require(totalSupply() + msg.value <= MAX_SUPPLY, "Max supply exceeded");
        
        deposits[msg.sender] += msg.value;
        _mint(msg.sender, msg.value);
        
        emit Deposit(msg.sender, msg.value, msg.value);
    }

    /// @notice Withdraw deposited ETH (1:1 ratio with tokens)
    /// @param amount Amount of tokens to burn and receive as ETH
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be positive");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(deposits[msg.sender] >= amount, "Insufficient deposits");
        
        deposits[msg.sender] -= amount;
        _burn(msg.sender, amount);
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(msg.sender, amount);
    }

    /// @notice Get voting power of an address at current block
    /// @param account Address to check voting power
    /// @return Current voting power
    function getVotes(address account) public view override(ERC20Votes) returns (uint256) {
        return super.getVotes(account);
    }

    /// @notice Get past voting power at specific block
    /// @param account Address to check voting power
    /// @param blockNumber Block number to check at
    /// @return Voting power at specified block
    function getPastVotes(address account, uint256 blockNumber)
        public
        view
        override(ERC20Votes)
        returns (uint256)
    {
        return super.getPastVotes(account, blockNumber);
    }

    /// @notice Get total voting power at current block
    /// @return Total voting power
    function _getVotingUnits(address account)
        internal
        view
        override(ERC20Votes)
        returns (uint256)
    {
        return balanceOf(account);
    }

    // Required overrides
    function _update(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, amount);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}

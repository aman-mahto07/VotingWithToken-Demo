# VotingWithToken Smart Contract

A minimal voting system written in Solidity that rewards voters with ERC20-like tokens. This implementation is designed for simplicity and transparency, with no imports or constructors.

## Contract Information

* **Network:** Flow EVM Testnet
* **Contract Address:** `0x28F70623eDd7641549eF7537ecDFEFac23727D3F`
* **Token Symbol:** VOTE
* **Reward per Vote:** 10 VOTE

## Overview

Each user can vote once on a proposal. When a user votes, they receive `VOTE` tokens as a reward. Anyone can add proposals, and users can burn tokens to reset their voting eligibility.

## Features

* Internal ERC20-like token implementation
* Token minting as vote rewards
* Open proposal creation
* Ability to burn tokens to vote again
* No external imports or constructors

## Functions

| Function                                                 | Description                        |
| -------------------------------------------------------- | ---------------------------------- |
| `vote(uint256 proposalId)`                               | Vote on a proposal and earn tokens |
| `addProposal(string description)`                        | Add a new proposal                 |
| `burnAndResetVote()`                                     | Burn tokens to reset vote status   |
| `transfer(address to, uint256 amount)`                   | Transfer VOTE tokens               |
| `approve(address spender, uint256 amount)`               | Approve token spending             |
| `transferFrom(address from, address to, uint256 amount)` | Transfer tokens via allowance      |

## Deployment

This contract is already deployed on the Flow EVM Testnet. You can interact with it through any Web3-compatible wallet or tool (Remix, Foundry, Hardhat, etc.) configured for the Flow EVM Testnet.



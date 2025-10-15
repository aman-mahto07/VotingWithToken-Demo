# VotingWithToken

A decentralized voting smart contract written in Solidity that rewards voters with tokens for participation.  
It is fully self-contained, with no imports or constructors, making it simple and efficient for learning or experimentation.

## Contract Details
- **Network:** Flow EVM Testnet  
- **Address:** 0x28F70623eDd7641549eF7537ecDFEFac23727D3F  
- **Token Symbol:** VOTE  
- **Reward per Vote:** 10 VOTE  

## Overview
Users can vote on proposals and automatically receive VOTE tokens as rewards.  
Anyone can add new proposals to the system, promoting an open and transparent governance process.  
To vote again, a user can burn a small number of tokens to reset their voting status.  

## Key Features
- Reward system integrated with each vote  
- Open proposal submission  
- Built-in ERC20-like token (transfer, approve, transferFrom)  
- No external dependencies or constructors  
- Prevents accidental ETH transfers  

## Purpose
Ideal for DAO experiments, prototype governance systems, or blockchain education.  
This project demonstrates how token incentives can be directly linked to decentralized decision-making.


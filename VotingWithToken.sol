// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Voting system that rewards participants with an internal ERC20-like token.
// Constraints followed: no imports, no constructor.

contract VotingWithToken {
    // --- Simple ERC20-like token state ---
    string public constant name = "VoteToken";
    string public constant symbol = "VOTE";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // --- Voting state ---
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;

    // Reward per vote (18 decimals)
    uint256 public constant REWARD_PER_VOTE = 10 * (10 ** 18);

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Voted(address indexed voter, uint256 indexed proposalId);
    event ProposalAdded(uint256 indexed proposalId, string description);

    // --- No constructor required. Instead we pre-seed some proposals at declaration-time.
    // Note: Solidity does allow initializing storage variables at declaration; here we do it in the contract body using an internal helper call that runs when deployed.

    // A deploy-time initializer trick: use a constant boolean to call internal initializer during deployment.
    // This pattern avoids using an explicit constructor while still setting initial proposals.
    bool private _initDone = _initializer();

    function _initializer() private returns (bool) {
        // Predefined proposals (change text as needed)
        proposals.push(Proposal({description: "Increase project budget", voteCount: 0}));
        proposals.push(Proposal({description: "Adopt new feature X", voteCount: 0}));
        proposals.push(Proposal({description: "Open-source part of the codebase", voteCount: 0}));
        // Note: totalSupply starts at 0; tokens are minted when voting.
        return true;
    }

    // --- Voting function ---
    function vote(uint256 proposalId) external {
        require(proposalId < proposals.length, "Invalid proposal id");
        require(!hasVoted[msg.sender], "Already voted");

        hasVoted[msg.sender] = true;
        proposals[proposalId].voteCount += 1;

        // Mint reward to voter
        _mint(msg.sender, REWARD_PER_VOTE);

        emit Voted(msg.sender, proposalId);
    }

    // --- Admin-free proposal additions (anyone can suggest). No constructor means no owner — trust-minimized but public. ---
    function addProposal(string calldata description) external {
        proposals.push(Proposal({description: description, voteCount: 0}));
        emit ProposalAdded(proposals.length - 1, description);
    }

    // --- Token internals ---
    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Mint to zero");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "Allowance exceeded");
        allowance[from][msg.sender] = allowed - amount;
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Transfer to zero");
        uint256 senderBalance = balanceOf[from];
        require(senderBalance >= amount, "Insufficient balance");
        balanceOf[from] = senderBalance - amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }

    // --- View helpers ---
    function proposalCount() external view returns (uint256) {
        return proposals.length;
    }

    function proposalDescription(uint256 id) external view returns (string memory) {
        require(id < proposals.length, "Invalid id");
        return proposals[id].description;
    }

    function proposalVotes(uint256 id) external view returns (uint256) {
        require(id < proposals.length, "Invalid id");
        return proposals[id].voteCount;
    }

    // --- Utility: allow re-voting in exchange for burning tokens (optional) ---
    // This function lets someone reset their voted status if they burn a fixed amount of tokens.
    // It demonstrates token economics but is optional for your use-case.
    function burnAndResetVote() external returns (bool) {
        uint256 burnAmount = 5 * (10 ** 18);
        require(balanceOf[msg.sender] >= burnAmount, "Not enough tokens to burn");
        balanceOf[msg.sender] -= burnAmount;
        totalSupply -= burnAmount;
        emit Transfer(msg.sender, address(0), burnAmount);

        hasVoted[msg.sender] = false;
        return true;
    }

    // --- Safety: fallback/receive to prevent accidental ETH send ---
    receive() external payable {
        revert("No ETH accepted");
    }

    fallback() external payable {
        revert("Invalid call");
    }
}


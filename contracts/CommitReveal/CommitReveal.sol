// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatternComitReveal {
  address immutable _owner;

  bool votingStopped;
  mapping(address => bytes32) public commits;
  mapping(address => uint256) public votes;

  address[] public candidate = [
    0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
    0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
    0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
  ];

  modifier onlyOnwer() {
    require(_owner == msg.sender, "Access only owner");
    _;
  }

  constructor() {
    _owner = msg.sender;
  }

  function commitVote(bytes32 _hashedVote) external {
    require(!votingStopped, "voting don't stop");
    require(commits[msg.sender] == bytes32(0), "User Alredy Voted");

    commits[msg.sender] = _hashedVote;
  }

  function revealVote(address _candidate, bytes32 _secret) external {
    require(votingStopped, "Voting not stop");

    bytes32 commit = keccak256(
      abi.encodePacked(_candidate, _secret, msg.sender)
    );

    require(commit == commits[msg.sender], "this not your candidate");

    delete commits[msg.sender];
    votes[_candidate]++;
  }

  function stopVoting() external onlyOnwer {
    require(!votingStopped, "");

    votingStopped = true;
  }
}

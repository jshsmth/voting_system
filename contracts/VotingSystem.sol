// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract VotingSystem {
    struct Candidate {
        uint8 id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint8 public candidatesCount = 0;

    uint public startTime;
    uint public endTime;

    event VotedEvent(uint indexed _candidateId);

    constructor(uint _durationInMinutes) {
        startTime = block.timestamp;
        endTime = startTime + (_durationInMinutes * 1 minutes);

        addCandidate("Bob");
        addCandidate("Alice");
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "Voting is not allowed at this time."
        );
        require(!voters[msg.sender], "You have already voted bro.");
        require(
            _candidateId > 0 && _candidateId <= candidatesCount,
            "You have entered an invalid ID."
        );

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VotedEvent(_candidateId);
    }

    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory candidateArray = new Candidate[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            candidateArray[i - 1] = candidates[i];
        }

        return candidateArray;
    }

    function getWinner() public view returns (string memory) {
        require(block.timestamp > endTime, "Voting is still ongoing.");

        uint maxVotes = 0;
        uint leadingCandidateId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                leadingCandidateId = i;
            }
        }

        if (leadingCandidateId == 0) {
            return "No votes yet!";
        }

        return candidates[leadingCandidateId].name;
    }
}

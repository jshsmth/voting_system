import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { expect } from "chai";
  import hre from "hardhat";



  describe("VotingSystem", function () {
    it("Should return the list of candidates", async function () {
        const VotingSystem = await hre.ethers.getContractFactory("VotingSystem");
        const deployedVotingSystem = await VotingSystem.deploy(5);

        const candidates = await deployedVotingSystem.getAllCandidates();
        expect(candidates).to.have.length(2);
    });
    it("Should return the winner after the voting period", async function () {
        const VotingSystem = await hre.ethers.getContractFactory("VotingSystem");
        const deployedVotingSystem = await VotingSystem.deploy(5);

        // call the vote function
        await deployedVotingSystem.vote(1);

        const deploymentTime = await time.latest();
        const votingEndTime = deploymentTime + (5 * 60);
        await time.increaseTo(votingEndTime + 1000); 

        const winner = await deployedVotingSystem.getWinner();
        expect(winner).to.equal("Bob");
    });
  });

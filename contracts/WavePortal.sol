// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalwaves;

    // seed to help generate a random number
    uint256 private seed;

    // A little magic, Google what events are in Solidity
    // Events are convenience interfaces with the EVM logging facilities.
    // https://docs.soliditylang.org/en/v0.5.3/contracts.html#events

    event NewWave(address indexed from, uint256 timestamp, string message);

    // Created a struct here named Wave.
    // A struct is basically a custom datatype where we can customize what we want to hold inside it

    struct Wave {
        address waver; // The adress of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestampt when the user waved.
    }

    // Declare a variable waves that lets me store an array of structs.
    // This is what lets hold the waves anyone ever send to me!
    // Because we deploy the contract on blockchain, this variable will never be reset as long as the blockchain is alive
    Wave[] waves;

    constructor() payable {
        console.log("Learn Blockchain from BuildSpace! - haziqkamel");
        // Set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        totalwaves += 1;
        console.log("%s has waved! with message: %s", msg.sender, _message);

        // Storing the wave data in an array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        // Give a 50% chance that the user wins the prize.
        if (seed <= 50) {
            // Reward waver
            uint256 prizeAmount = 0.0001 ether;

            // Checks to see that some condition is true.
            // If it's not true, it will quit the function and cancel the transaction. It's like a fancy if statement!
            //
            // Let us make sure that the balance of the contract is bigger than the prize amount,
            // and if it is, we can move forward with giving the prize!
            //
            // If it isn't require will essentially kill the transaction and be ike, "Yo, this contract can't even pay you out!"
            require(
                prizeAmount <= address(this).balance, //balance of the contract itself
                "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // send money
            require(success, "Failed to withdraw money from contract"); // know if the transaction was a success
        }

        // Addes some fanciness here, Google it and figure it out
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    // Added a function getAllWaves which will return the struct array, waves, to us.
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalwaves);
        return totalwaves;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Lottery{
    address public owner;
    address payable[] public players;  // Array
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;

    constructor() {
        owner = msg.sender; // owner address person who deployed the contract
        lotteryId = 1;
    }
function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
}

function getBalance() public view returns (uint) { // publicly show the lottery price
        return address(this).balance;
    }

function getPlayers() public view returns (address payable[] memory) {
        return players;
    } 

function enter() public payable { // For buy Lottery
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));                              // push = add item in array & person who wants to join the lottery.

    }
function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }
function pickWinner() public onlyOwner{
       uint index = getRandomNumber() % players.length;
       players[index].transfer(address(this).balance); // players[index] = Take the winner.

       lotteryHistory[lotteryId] = players[index];
       lotteryId++;

       // reset the state of the contract
       players = new address payable[](0); // ready for next round of play
    }

modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
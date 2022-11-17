// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CarShowroom{
    address public owner;
    mapping(address => uint) public carValue;

    constructor(){
        owner =(msg.sender);
        carValue[address(this)] = 100;
    //    uint  carValue = 100 ether;
        
    }
    function buyTheCar(uint amount) public payable {
        require(msg.value >= amount * 2 ether, "You must pay atleast 100 eather for a car");
        require(carValue[address(this)] >= amount, "");
        carValue[address(this)] -= amount;
        carValue[msg.sender] += amount;
    }
    function restockTheCar(uint amount) public{
        require(msg.sender == owner, "Only owner can restock the cars in the showroom.");
        carValue[address(this)] += amount;
    }
    function getBalance() public view returns(uint) {
        return carValue[address(this)];
    }
}
        
        



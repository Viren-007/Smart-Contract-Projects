// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract trainTicket {
    uint256 public sleepercost = 0.2 ether;
    uint256 public thirdcost = 0.3 ether;
    uint256 public secondcost = 0.4 ether;
    uint256 public firstcost = 0.5 ether;

    // Event for buyTicket function
    event BoughtTicket(address indexed _from, uint256 cost);

    // When we buy multipal tickets use "Modifier" function,and check each one msg is equal to the cost.
    modifier shouldPay(uint256 _cost) {
        require(msg.value >= _cost, "The sheet cost more!"); //it tell us that the logic needes to be true otherwise it will filles
        _;
    }

    function buySleeperTicket() public payable shouldPay(sleepercost) {
        emit BoughtTicket(msg.sender, sleepercost); // for event use emit function
    }

    function buyThirdTicket() public payable shouldPay(thirdcost) {
        emit BoughtTicket(msg.sender, thirdcost); // for event use emit function
    }

    function buySecondTicket() public payable shouldPay(secondcost) {
        emit BoughtTicket(msg.sender, secondcost); // for event use emit function
    }

    function buyFirstTicket() public payable shouldPay(firstcost) {
        emit BoughtTicket(msg.sender, firstcost); // for event use emit function
    }

    function refund(address _to, uint256 _cost) public payable {
        // add require statement for refund the currect value when person bought differnt types of tickes.
        require(
            _cost == sleepercost ||
                _cost == thirdcost ||
                _cost == secondcost ||
                _cost == firstcost
        ); // block accidently refund by owner
        uint256 balanceBeforeTransfer = address(this).balance; // What happen no one can bought tickes but yet to be trying to refund.
        // call function for refund the amount
        if (balanceBeforeTransfer >= _cost) {
            (bool success, ) = payable(_to).call{value: _cost}("");
            require(success);
        }
        // is useed for internal logics checks.use when something went goes.
        else {
            revert("Not enough funds!");
        }
        assert(address(this).balance == balanceBeforeTransfer - _cost);
    }

    function getFunds() public view returns (uint256) {
        return address(this).balance;
    }
}

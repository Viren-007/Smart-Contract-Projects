// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract airlineticket {
    uint256 public economycost = 0.5 ether;
    uint256 public businesscost = 0.8 ether;

    // Event for buyTicket function
    event boughtAirlineTicket(address indexed _from, uint256 cost);

    // When we buy multipal tickets use "Modifier" function,and check each one msg is equal to the cost.
    modifier shouldPay(uint256 _cost) {
        require(msg.value >= _cost, "The ticket cost more!"); //it tell us that the logic needes to be true otherwise it will filles
        _;
    }

    function buyEconomyTicket() public payable shouldPay(economycost) {
        emit boughtAirlineTicket(msg.sender, economycost); // for event use emit function
    }

    function buyBusinessTicket() public payable shouldPay(businesscost) {
        emit boughtAirlineTicket(msg.sender, businesscost); // for event use emit function
    }

    function refund(address _to, uint256 _cost) public payable {
        // add require statement for refund the currect value when person bought differnt types of tickes.

        require(
            _cost == economycost || _cost == businesscost,
            "You are trying to refunds the wrong amount!"
        ); // block accidently refund by owner
        uint256 balanceBeforeTransfer = address(this).balance; // What happen no one can bought tickes but yet to be trying to refund.
        // call function for refund the amount
        if (balanceBeforeTransfer >= _cost) {
            (bool success, ) = payable(_to).call{value: economycost}("");
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

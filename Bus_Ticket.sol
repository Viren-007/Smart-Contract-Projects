// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract sheetBooking {
    uint256 public sheetCost = 0.2 ether;
    uint256 public singleSleeperCost = 0.2 ether;
    uint256 public doubleSleeperCost = 0.2 ether;

    // Event for buyTicket function
    event boughtBusTicket(address indexed _form, uint256 cost);

    // When we buy multipal tickets use "Modifier" function,and check each one msg is equal to the cost.
    modifier shouldPay(uint256 _cost) {
        require(msg.value >= _cost, "The sleeper cost more!"); //it tell us that the logic needes to be true otherwise it will filles
        _;
    }

    function buySheet() public payable shouldPay(sheetCost) {
        emit boughtBusTicket(msg.sender, sheetCost); // for event use emit function
    }

    function buySingleSleeper() public payable shouldPay(singleSleeperCost) {
        emit boughtBusTicket(msg.sender, singleSleeperCost); // for event use emit function
    }

    function buyDoubleSleeper() public payable shouldPay(doubleSleeperCost) {
        emit boughtBusTicket(msg.sender, doubleSleeperCost); // for event use emit function
    }

    function refund(address _to, uint256 _cost) public payable {
        // add require statement for refund the currect value when person bought differnt types of tickes.
        require(
            _cost == sheetCost ||
                _cost == singleSleeperCost ||
                _cost == doubleSleeperCost
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

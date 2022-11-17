// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract HotelRoom {
    uint256 public singleRoomCost = 0.2 ether;
    uint256 public doubleRoomCost = 0.3 ether;

    // Event for buy a hotel room function
    event boughtRoom(address indexed _from, uint256 cost);

    // When we buy multipal tickets use "Modifier" function,and check each one msg is equal to the cost.
    modifier shouldPay(uint256 _cost) {
        require(msg.value >= _cost, "The king size room cost more!"); //it tell us that the logic needes to be true otherwise it will filles
        _;
    }

    function buySingleRoom() public payable shouldPay(singleRoomCost) {
        emit boughtRoom(msg.sender, singleRoomCost); // for event use emit function
    }

    function buyDoubleRoom() public payable shouldPay(doubleRoomCost) {
        emit boughtRoom(msg.sender, doubleRoomCost); // for event use emit function
    }

    // use "address _to" for refund amount
    function refund(address _to, uint256 _cost) public payable {
        // add require statement for refund the currect value when person bought differnt types of tickes.
        require(
            _cost == singleRoomCost || _cost == doubleRoomCost,
            "You are trying to refunds the wrong amount!"
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

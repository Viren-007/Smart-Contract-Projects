// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EventContract{
struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
             }
       // Orgainzer are organize multipal events at a time
    //    so we can use "Mapping function" for this.
    mapping (uint=>Event)public events;      // uint = means which event comes at which number.
    mapping (address=>mapping (uint=>uint)) public tickets; // this mapping are hold our ticketes.
    uint public nextId; // event ticket Id no.

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
        require(date>block.timestamp,"You can orgainze event for future date");
        require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
        
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount); // two times ticketCounts use for in the starting remaining ticketcounts are same
        nextId++;
    }
    function buyTicket(uint id, uint quantity) external payable {
           // coustomer buy tickets for future event and check the schedule
       require(events[id].date!=0,"Event does not existe"); // beacuse of initially date is 0.
          //  check the event vanue and date is he there that day
       require(events[id].date>block.timestamp,"Event has already occured!");
       Event storage _event = events[id]; // check pay value are <= ticket value
       require(msg.value==(_event.price*quantity),"Ether is not enough"); // check pay value are <= value and quantity of the ticket 
       require(_event.ticketRemain>= quantity,"Not enough ticktes"); // check ticket availability there is enough ticket
       _event.ticketCount-= quantity; // After sell the ticket ticketcount no. decrease.
       tickets[msg.sender][id]+=quantity; // use muitipal show
    }
    function transferTicket(uint id, uint quantity, address to) external {
        // coustomer buy tickets for future event and check the schedule
       require(events[id].date!=0,"Event does not existe"); // beacuse of initially date is 0.
          //  check the event vanue and date is he there that day
       require(events[id].date>block.timestamp,"Event has already occured!");

       require(tickets[msg.sender][id]>= quantity,"You donot have enough tickets"); // You have enough ticket quantity for transfer.
       tickets[msg.sender][id]-=quantity; // From
       tickets[to][id]+=quantity;
    }
}




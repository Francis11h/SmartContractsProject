// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract LuckyDraw {

    struct Participant {
        address payable participant_address;
        uint amount;
    }

    Participant participantInfo;
    Participant[] public participants;

    address payable public manager;

    uint public totalParticipants;
    uint public contractBalance;

    address payable public winner;

    modifier isPaymentEnough() {
        require(msg.value >= 0.5 ether);
        _;
    }

    modifier restricted() {
        require(msg.sender == manager); //only manager can modify this 
        _;
    }

    modifier ifOnlyHasParticipants() {
        require(totalParticipants > 0);
        _;
    }

    constructor() {
        manager = msg.sender;
    } 

    function enterLuckyDraw() public payable isPaymentEnough {
        participantInfo = Participant(msg.sender, msg.value);
        participants.push(participantInfo);

        updateCondition();
    }

    // use block difficulty and current time to generate a random number in hexadecimal
    function random() private view returns(uint) {
        // todo ehat is keccak256
        return uint(keccak256 (abi.encodePacked(block.difficulty, block.timestamp))) % totalParticipants;
    } 

    function findWinner() public restricted ifOnlyHasParticipants {
        uint index = random();
        //find the winner
        winner = participants[index].participant_address;
        //Sending the whole contract balance to a winner
        winner.transfer(address(this).balance);
        //Resetting the contract state Delete all participants and start a new game
        for (uint x = 0; x < totalParticipants; x++) {
            participants.pop();
        }
        updateCondition();
    }

    function updateCondition() private {
        contractBalance =  address(this).balance; 
        totalParticipants = participants.length; 
    }

    function destroyContract() public restrict {
        selfdestruct(manager);
    }
}
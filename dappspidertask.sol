// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
    contract crowdfunding{
        mapping(address=>uint) public contributors;
        address public manager; 
        uint public minimumContribution;
        uint public deadline;
        uint public target;
        uint public raisedAmount;
        uint public noOfContributors;

        constructor(uint _target, uint _deadline){
            target = _target;
            deadline = block.timestamp+_deadline;
            minimumContribution = 100 wei;
            manager = msg.sender;
        }
        function sendEth() public payable{
            require(block.timestamp<deadline, "deadline has passed");
            require(msg.value >=minimumContribution, "minimum contribution is not met");
            if(contributors[msg.sender]==0){
                noOfContributors++;
            }
            contributors[msg.sender]+=msg.value;
            raisedAmount+=msg.value;
        }
        function getContractBalance() public view returns(uint){
            return address(this).balance; 
        }
        function refund() public{
            require(block.timestamp>deadline && raisedAmount<target, "you are not eligible to get refund");
            require(contributors[msg.sender]>0);
            address payable user = payable(msg.sender);
            user.transfer(contributors[msg.sender]);
        }
    }
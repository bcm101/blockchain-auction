// SPDX-License-Identifier: UNLICENSED

pragma solidity >0.4.0 <0.9.0;

contract Auction {
    // mapping of all bid by bidder address
    mapping(address => uint) internal bids;

    // define general auction state variables
    address owner;
    address public highestBidder;
    address[] bidders;

    uint public startTime;
    uint public endTime;

    // define 
    struct Item {
        string name;
        string description;
        string Rnumber;
    }

    enum auction_state {
        STARTED, CANCELLED
    }

    Item public item;
    auction_state public STATE;

    event BidEvent(address indexed highestBidder, uint256 highestBid);
    event WithdrawalEvent(address withdrawer, uint256 amount);
    event CancelledEvent(string message, uint256 time);  

    constructor(uint _auctionTime, string memory _name, string memory _description, string memory _Rnumber){

        item.name = _name;
        item.description = _description;
        item.Rnumber = _Rnumber;

        STATE = auction_state.STARTED;

        startTime = block.timestamp;
        endTime = startTime + _auctionTime;
        owner = msg.sender;
    }

    modifier _ownerOnly(){
        require(msg.sender == owner, "only owner has access to these functions"); 
        _;
    }
    modifier _auctionActive(){
        require(block.timestamp < endTime, "auction has ended"); 
        require(STATE == auction_state.STARTED, "auction has ended");
        _;
    }

    function getContractBalance() _ownerOnly _auctionActive public view returns(uint){
        return address(this).balance;
    }

    function getBidderBid(address _address) _ownerOnly _auctionActive public view returns(uint){
        return bids[_address];
    }

    function getHighestBidder() _ownerOnly _auctionActive public view returns(address){
        return highestBidder;
    }

    function endAuction() _ownerOnly _auctionActive public returns(address){
        STATE = auction_state.CANCELLED;

        emit CancelledEvent("Auction Cancelled", block.timestamp);

        return highestBidder;
    }


    function withdrawBid(address payable _address) _ownerOnly _auctionActive public{
        uint256 amount = bids[_address];
        
        require(amount > 0, "No active bid");
        
        _address.transfer(amount);
        bids[msg.sender] = 0;

        emit WithdrawalEvent(msg.sender, amount);
    }

    // general bidder functions
    function getYourBid() _auctionActive public view returns(uint){
        return bids[msg.sender];
    }

    function createBid() _auctionActive public payable{

        uint totalAmount = bids[msg.sender] + msg.value;

        require(msg.value > 0, "Improper bid amount");
        require(bids[highestBidder] < totalAmount, "Amount not high enough");
        
        bids[msg.sender] = totalAmount;
        highestBidder = msg.sender;

        emit BidEvent(highestBidder, bids[msg.sender]);

    }

    function withdrawYourBid() public{
        require(STATE == auction_state.CANCELLED, "auction hasn't ended yet");
        require(bids[msg.sender] > 0, "No active bid");

        payable(msg.sender).transfer(bids[msg.sender]);
    }

}
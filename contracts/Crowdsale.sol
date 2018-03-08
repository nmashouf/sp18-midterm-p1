pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */



contract Crowdsale {
	// YOUR CODE HERE
	//keep track of number tokens sold, start & end time, 
	uint endTime;
	uint initialNumTokens;
	uint tokensPerWei;
	uint tokensSold;
	uint totalSupply;
	uint private fundsRaised; //units are wei
	address public owner;
	bool crowdsaleStarted = false;



	mapping(address => uint) balanceOf; //units are tokens
	Token public token;
	Queue public queue;

	function Crowdsale(uint _endtime, uint _initialNumTokens, uint _tokensPerWei) {
		owner = msg.sender;
		endTime = _endtime;
		initialNumTokens = _initialNumTokens;
		totalSupply = _initialNumTokens;
		tokensPerWei = _tokensPerWei;
		crowdsaleStarted = true;

	}

	//MODIFIERS

	modifier requireOwner() {
		if (msg.sender != owner) {
			return;
		}
		_;
	}

	modifier withinTime() {
		if (!crowdsaleStarted || now > endTime){
			return;
		}
		_;
	}

	modifier abletoBurn() {
		if(totalSupply < msg.value){
			return;
		}
		_;
	}

	modifier saleOpen() {
		if (now > endTime){
			return;
		}
		_;
	}
	// OWNER only

	//add new tokens to totalSupply
	function mint(uint _numNewTokens) requireOwner() {
		token.addTokens(_numNewTokens);
	}

	//remove tokens from totalSupply
	function burn(uint _numTokens) requireOwner() abletoBurn() {
		token.burnTokens(_numTokens);
	}

	function withdrawWhenClosed() requireOwner(){
		if (now > endTime){
			owner.transfer(fundsRaised);
		}
	}

	//BUYERS

	function buyTokens(uint _numTokens) public saleOpen() {
		if (msg.sender == queue.getFirst() && queue.qsize() > 1) {
			tokensSold += _numTokens;
			balanceOf[msg.sender] += _numTokens;
			tokensSold += _numTokens;
			fundsRaised += _numTokens/tokensPerWei;
			queue.dequeue(msg.sender);
			TokenPurchase(msg.sender);
		}
	}

	function refundTokens(uint _numTokens) public saleOpen() {
		if (balanceOf[msg.sender] > 0){
			balanceOf[msg.sender] -= _numTokens;
			msg.sender.transfer(_numTokens/tokensPerWei);
			funds -= _numTokens/tokensPerWei;
			TokenRefund(msg.sender);
		}
	}

	function joinQueue() public saleOpen() returns (bool success) {
		if(queue.qsize() < queue.size) {
			queue.enqueue(msg.sender);
			return true;
		}
		return false;
	}

	// Events 
	event TokenPurchase(address buyer);
	event TokenRefund(address buyer);


}

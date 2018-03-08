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
	uint private fundsRaised;
	address public owner;
	bool crowdsaleClosed = false;



	mapping(address => uint) balanceOf;
	Token public token;
	Queue public queue;

	function Crowdsale(uint _endtime, uint _initialNumTokens, uint _tokensPerWei, ) {
		owner = msg.sender;
		endTime = _endtime;
		initialNumTokens = _initialNumTokens;
		totalSupply = _initialNumTokens
		tokensPerWei = _tokensPerWei;

	}

	modifier requireOwner() {
		if (msg.sender != owner) {
			return;
		}
		_;
	}

	modifier withinTime() {
		if (now < startTime || now > endTime){
			return;
		}
		_;
	}

	modifier abletoBurn() {
		require(totalSupply() > msg.value);
		_;
	}

	// Owner only

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

	//Buyers

	function buyTokens(uint _numTokens) {
		if (msg.sender == queue.getFirst() && queue.qsize() > 1) {
			tokenSold += amount;
			balanceOf[msg.sender] += _numTokens;
			tokensSold += _numTokens;
			fundsRaised += msg.value;

		}

	}
	// Events 
	event TokenPurchase(address buyer);
	event TokenRefund(address buyer);


}

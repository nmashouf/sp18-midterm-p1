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
	address public owner;
	bool crowdsaleClosed = false;



	mapping(address => uint) balanceOf;
	Token public token;
	Queue public queue;

	function Crowdsale(uint _endtime, uint _initialNumTokens, uint _tokensPerWei, ) {
		owner = msg.sender;
		endtime = _endtime;
		initialNumTokens = _initialNumTokens;
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
		if crowdsaleClosed{
			transfer
		}
	}

	//Buyers

	function buyTokens(uint _numTokens) {
		if (msg.sender == queue.getFirst() && queue.qsize() > 1) {
			tokenSold += amount;

		}

	}



}

pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import '.Crowdsale.sol';
/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
	// Get the total token supply
	function totalSupply() constant returns (uint256 totalSupply) {
		return totalSupplyVal;
	}

	// Get the account balance of another account with address _owner
	function balanceOf(address _owner) constant returns (uint256 balance);

	function addTokens(uint amount) public returns (bool success){
		var bal = totalSupply();
		var newBal = bal + amount;
		if( newBal > bal) {
			bal = newBal;
			return true;
		} else {
			return false;
		}
		
	}

	function burnTokens(uint amount) public returns (bool success){
		var bal = totalSupply();
		if(bal >= amount){
			bal -= amount;
			return true;
		} else {
			return false;
		}
		
	}

	// Send _value amount of tokens to address _to
	function transfer(address _to, uint256 _value) returns (bool success);

	// Send _value amount of tokens from address _from to address _to
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
	// If this function is called again it overwrites the current allowance with _value.
	// this function is required for some DEX functionality
	function approve(address _spender, uint256 _value) returns (bool success);

	// Returns the amount which _spender is still allowed to withdraw from _owner
	function allowance(address _owner, address _spender) constant returns (uint256 remaining);

	// Triggered when tokens are transferred.
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	// Triggered whenever approve(address _spender, uint256 _value) is called.
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

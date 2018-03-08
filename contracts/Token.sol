pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './Crowdsale.sol';
/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
	uint256 constant private MAX_UINT256 = 2**256 - 1;
	uint256 initialNumTokens;
	mapping(address => uint) balances; //units are tokens
	mapping (address => mapping (address => uint256)) public allowed;
	
	function Token(uint256 _initialNumTokens) public {
		initialNumTokens = _initialNumTokens;
        balances[msg.sender] = _initialNumTokens;               // Give the creator all initial tokens
        totalSupply = initialNumTokens;                        // Update total supply
       
    }

	// Get the account balance of another account with address _owner
	function balanceOf(address _owner) constant returns (uint256 balance) {
		return balances[_owner];
	}

	function addTokens(uint amount) public returns (bool success){
		var newBal = totalSupply + amount;
		if( newBal > totalSupply) {
			totalSupply = newBal;
			return true;
		} else {
			return false;
		}
		
	}

	function burnTokens(uint amount) public returns (bool success){
		if(totalSupply >= amount){
			totalSupply -= amount;
			return true;
		} else {
			return false;
		}
	}

	// Send _value amount of tokens to address _to
	function transfer(address _to, uint256 _value) returns (bool success) {
		if(balances[msg.sender] >= _value){
			balances[msg.sender] -= _value;
        	balances[_to] += _value;
        	Transfer(msg.sender, _to, _value);
        	return true;
		}
		return false;
        
	}

	// Send _value amount of tokens from address _from to address _to
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
		uint256 allowance = allowed[_from][msg.sender];

        if(balances[_from] >= _value && allowance >= _value){
        	balances[_to] += _value;
        	balances[_from] -= _value;
        	if (allowance < MAX_UINT256) {
            	allowed[_from][msg.sender] -= _value;
        	}
        	Transfer(_from, _to, _value);
        	return true;
        }
        return false;
        
	}

	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
	// If this function is called again it overwrites the current allowance with _value.
	// this function is required for some DEX functionality
	function approve(address _spender, uint256 _value) returns (bool success){
		allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
	}

	// Returns the amount which _spender is still allowed to withdraw from _owner
	function allowance(address _owner, address _spender) constant returns (uint256 remaining){
		return allowed[_owner][_spender];
	}

	// Triggered when tokens are transferred.
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	// Triggered whenever approve(address _spender, uint256 _value) is called.
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

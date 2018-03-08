pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint time;
	uint8 numOccupied;
	// YOUR CODE HERE
	address[] queue;

	/* Add events */
	// YOUR CODE HERE

	/* Add constructor */
	// YOUR CODE HERE
	function Queue() {
		queue = new address[](size);
		time = now;
		numOccupied = 0;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return numOccupied;
	}

	function size() constant returns(uint8) {
		return size;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
		return numOccupied == 0;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
		return queue[0];
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
		for (uint8 i = 0; i<queue.length; i++){
			if(msg.sender == queue[i]) {
				return i;
			}
		}
		return size + 1;	/* indicatetion of the fact that it is not in the list */

	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		/* our limit to be in front is an hour */
		int256 hour = 60;
		int256 hour2 = -60;
		int256 diff = (int256) (now - time);
		if (diff > hour || diff < hour2){
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		/* removing the first person by moving everyone else one to the front*/
		for (uint i = 0; i<queue.length; i++){
			if(i != queue.length - 1) {
				queue[i] = queue[i + 1];
			} else {
				queue[i] = 0;
			}
		}
		numOccupied -= 1;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		if(numOccupied != queue.length) {
			queue[numOccupied] = addr;
				numOccupied += 1;
		}
	}

}

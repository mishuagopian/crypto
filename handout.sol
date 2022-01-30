// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";

// Creating a contract
contract HandOut is Ownable {
	// Declaring the state variable
	address payable public _address;

	constructor() {
		_address = payable(msg.sender);
	}

	function setAddress(address payable newAddress) public onlyOwner {
		_address = newAddress;
	}
	
	function getBalance() public view onlyOwner returns(uint256) {
		return address(this).balance;
	}

	function payout() public payable onlyOwner {
		_address.transfer(address(this).balance);
	}

	receive() payable external {}
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Owned {
  address private owner;

  constructor(){
    owner = msg.sender;
  }

  /**
      `onlyOwner` modifier can be applied to methods that should be accessed ony by the contract creator
   */
  modifier onlyOwner(){
    require(owner == msg.sender, "Only the owner can access this method");
    _;
  }

  function getCurrentOwner() external view onlyOwner returns(address){
    return owner;
  }

  function transferOwnership(address newOwner) external onlyOwner {
    owner = newOwner;
  }
}

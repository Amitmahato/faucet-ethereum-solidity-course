// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
    - An interface cannot declare a constructor
    - An interface cannot have storage, so cannot declare state variables
    
    - All the declared functions of an interface should be `external`
    - Functions in interfaces cannot have modifiers

    - An interface cannot inherit from any smart contracts
    - An interface can only inherit from other interfaces
 */

interface IFaucet {
  function addFunds() external payable;
  function withdraw(uint withdrawAmount) external;
}
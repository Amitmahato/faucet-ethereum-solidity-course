// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
    - Any child of the abstract contract has to implement the methods specified here
 */
abstract contract Logger {
  uint public testNum;

  constructor(){
    testNum = 100 + 100;
  }

  function emitLogs() public pure virtual returns(bytes32);
  function testFunc() public view virtual returns(uint){
    return testNum;
  }
}

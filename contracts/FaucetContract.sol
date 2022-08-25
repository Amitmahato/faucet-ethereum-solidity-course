// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
  
  /**
    - this is a special function
    - it's called when you make a tx that doesn't specify function name to call
    - It executes on calls to the contract with no data (calldata), e.g. calls made via send() or transfer().
    
    - External function are part of the contract interface 
      which means they can be called via contracts and other txs
   */

  receive() external payable {
    // React to receiving ether
  }

  function addFunds() external payable{}

  /**
    modifiers: `pure` & `view` - no any gas fee incurs 
      view - indicates the given function will not change the storage state in any way
      pure - even more strict, it will not even allow reading the storage state
   */
   function justTesting() external pure returns(uint) {
     return 2 + 2;
   }

  // Transactions: generates chanages in storage state & incurs gas fees


  // In order to talk to the nodes on the network, we can make JSON-RPC http call, 
  // which is actually being used internally by `truffle` & `web3`
}

// Block info
// Nonce - a hash that when combined with the minHash proves that
// the block has gone through proof of work(POW)
// 8 bytes => 64 bits
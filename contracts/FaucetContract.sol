// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
  
  // `public` - can be accessible throw the getter method outside the smart contract
  // `private` - can be accessible only within the smart contract
  // `internal` - can be accessible within the smart contract and also the derived smart contracts
  uint public numberOfFunders;
  uint fund;
  mapping(uint => address) public funders;

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

  function addFunds() external payable{
    uint index = numberOfFunders++;
    funders[index] = msg.sender;
    if (msg.value > 0) {
      fund += msg.value;
    }
  }

  function getAvailableFund() public view returns(uint) {
    return fund;
  }

  function getFunderAtIndex(uint index) public view returns ( address funder) {
    funder = funders[index];
  }

  function getAllFunders() public view returns(address[] memory) {
    address[] memory _funders = new address[](numberOfFunders);
    for (uint index = 0; index < numberOfFunders; index++) {
      _funders[index] = funders[index];
    }

    return _funders;
  }

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

/**
    Commands to:
     // get an instance of Faucet contract
     const instance = await Faucet.deployed();

     1. add funds 
     => await instance.addFunds({ from: accounts[0], value: 1500000000000000000 }) // 1.5 ETH
     => await instance.addFunds({ from: accounts[1], value: 1700000000000000000 }) // 1.7 ETH

     2. get fund
     => (await instance.getAvailableFund()).toString()

     3. get number of funders
     => (await instance.numberOfFunders()).toString();

     4. get funder at a given index
     => await instance.getFunderAtIndex(0);
     => await instance.getFunderAtIndex(1);
     => await instance.getFunderAtIndex(2);

     5. get a list of funders
     => await instance.getAllFunders();
 */
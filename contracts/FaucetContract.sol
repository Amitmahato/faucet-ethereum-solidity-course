// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Owned.sol";
import "./Logger.sol";

contract Faucet is Owned, Logger {
  
  // `public` - can be accessible throw the getter method outside the smart contract
  // `private` - can be accessible only within the smart contract
  // `internal` - can be accessible within the smart contract and also the derived smart contracts
  uint public numberOfFunders;
  uint private fund;
  struct FunderInfo {
    uint numberOfDonations;
    uint totalDonations;
  }
  mapping(address => FunderInfo) private funders;
  mapping(uint => address) private lookUpFunders;

  /**
      The modifier can be place at the definition of any method of the contract,
      and is something like a middleware, 
      this `limitWithdrawal` modifier can be reused as a modifier
      the `_` here will call the function body if the required conditions are passed
   */
  modifier limitWithdrawal(uint withdrawAmount){
    require(withdrawAmount <= 100000000000000000, "Withdraw amount cannot be greater than 0.1 ether");
    require(withdrawAmount <= fund, "Insufficient fund for the requested withdrawal amount");
    _;
  }

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

  function emitLogs() public override pure returns(bytes32){
    return "Hello Web3, from Faucet";
  }

  function addFunds() external payable{
    address funderAddress = msg.sender;

    if (msg.value > 0) {
      fund += msg.value;
    }

    if(funders[funderAddress].numberOfDonations == 0){
      uint index = numberOfFunders++;
      
      funders[funderAddress] = FunderInfo({
        numberOfDonations : 1,
        totalDonations : msg.value
      });

      lookUpFunders[index] = funderAddress;
    } else {
      funders[funderAddress].numberOfDonations += 1;
      funders[funderAddress].totalDonations += msg.value;
    }
  }

  function getAvailableFund() public view onlyOwner returns(uint) {
    return fund;
  }


  function withdraw(uint withdrawAmount) public limitWithdrawal(withdrawAmount) {
    payable(msg.sender).transfer(withdrawAmount);
    fund -= withdrawAmount;
  }

  function getFunderAtIndex(uint index) public view returns ( FunderInfo memory funder) {
    funder = funders[lookUpFunders[index]];
  }

  function getAllFunders() public view returns(FunderInfo[] memory) {
    FunderInfo[] memory _funders = new FunderInfo[](numberOfFunders);
    for (uint index = 0; index < numberOfFunders; index++) {
      _funders[index] = funders[lookUpFunders[index]];
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
     // 1.5 ETH
     => await instance.addFunds({ from: accounts[0], value: 1500000000000000000 });
     
     // 1.7 ETH
     => await instance.addFunds({ from: accounts[1], value: 1700000000000000000 });

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

     6. withdraw funds upto 1 ETH
     // withdraw 0.5 ETH 
     => await instance.withdraw("500000000000000000", { from: accounts[0] });

     // try to withdraw 1.5 ETH, although the transaction is successfull, the transfer of ether isn't actually made
     => await instance.withdraw("1500000000000000000", { from: accounts[0] });

     7. Access onlyOwner methods
     => await instance.getCurrentOwner();
     => await instance.transferOwnership(accounts[1]);
     
     // Will fail with error `Only the owner can access this method`, 
     //  since by default the from field is populated with accounts[0] but this account is not the owner
     => await instance.getCurrentOwner();
     
     // Will fail with error `Only the owner can access this method`, 
     //  since by default the from field is populated with accounts[0] but this account is not the owner
     => await instance.transferOwnership(accounts[0]);

     => await instance.getCurrentOwner({ from: accounts[1] }); // will be executed successfully

     8. Overriden emitLogs() method fromt the abstract Logger contract
     => await instance.emitLogs();
     => await instance.testFunc();
 */
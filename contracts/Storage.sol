// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


/**
 * address -> 20 bytes
 *
 * uint256 -> 32 bytes
 * uint128 -> 16 bytes
 * uint64  ->  8 bytes
 * uint32  ->  4 bytes
 * uint16  ->  2 bytes
 * uint8   ->  1 byte
 *
 * bool    ->  1 byte
 **/


contract Storage {

	uint8 public a = 7; // 1 byte -> slot 0 [cumulative -> 1 byte]
	uint16 public b = 10; // 2 bytes -> slot 0 [cumulative -> 1+2 = 3 bytes]
	address public c = 0x648FaaD551af1DA6d6556f0E3C41B37B6055bAD1; // 20 bytes -> slot 0 [cumulative -> 3+20 = 23 bytes]
	bool d = true; // 1 byte -> slot 0 [cumulative -> 23 + 1 = 24 bytes]
	uint64 public e = 15; // 8 bytes -> slot 0 [cumulative -> 24 + 8 = 32 byte]
	
  uint256 public f = 200; // 32 bytes -> slot 1
	
  uint8 public g = 40; // 1 byte -> slot 2 [1 byte from LSB]
  uint8 public j = 45; // 1 byte -> slot 2 [1 byte after LSB] (total 2 bytes from slot 2 are used and still 30 bytes are empty)
  uint256 public h = 789; // 32 bytes -> slot 3
  uint8 public i = 40; // 1 byte -> slot 2, 3 or 4 ? -> takes the slot 4, which means slot 2 still has unused space

  /**
      Location of mapping in the storage is calculated in a different way
      The location is calculated by finding the keccak256 encoding of the
      combination of the key and the slot
      i.e. location = keccak256(key . slot)
      ex: if key = 1 and slot = 5:
      32 bytes of key (64 characters) + 32 bytes of slot (64 characters) encoded by keccak256
      location = keccak256(00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000005)
   */
  mapping(uint => uint) aa; // slot 5
  mapping(address => uint) ab; // slot 6

  /**
      Location of dynamic array in the storage is calculated in following way:
      
      `location = hexadecimal( decimal(keccak256(32 bytes representation of slot)) + index of element in decimal)`

      or

      `location = keccak256(32 bytes representation of slot)) + hexadecimal( index of element in decimal )`

      Ex: here the slot is 7, i.e. 0x0000000000000000000000000000000000000000000000000000000000000007
      => keccak256("0x0000000000000000000000000000000000000000000000000000000000000007") 
      => ee2a4bc7db81da2b7164e56b3649b1e2a09c58c455b15dabddd9146c7582cebc

      So, the location of the items at corresponding index will be:
      index | location in storage
      0   ->  a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688 + 0x0
            = a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688

      1   ->  a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688 + 0x1
            = a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c689
          
      2   ->  a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688 + 0x2
            = a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c68a
          
      3   ->  a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688 + 0x3
            = a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c68b
          
      4   ->  a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688 + 0x4
            = a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c68c
  */
  uint[] public ac; // slot 7
  
  constructor(){
    ac.push(1); // index 0
    ac.push(10); // index 1
    ac.push(100); // index 2

    aa[4] = 40;
    aa[7] = 70;

    ab[0x7a02f64Cfe9a38a4ecFe4A91601aB789c1bFeb94] = 100;
  }

  /**
    1. aa[4]
      location for aa[4] = keccak256(0x00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000005)
                        = 0x3eec716f11ba9e820c81ca75eb978ffb45831ef8b7a53e5e422c26008e1ca6d5
      `web3.eth.getStorageAt("0x2890b9494a202F2D537Beb65E6100a8899E165a1", "0x3eec716f11ba9e820c81ca75eb978ffb45831ef8b7a53e5e422c26008e1ca6d5")`
      Output => '0x28' -> 40 in decimal
    
    2. aa[7]
      location for aa[4] = keccak256(0x00000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000005)
                        = 0xeddb6698d7c569ff62ff64f1f1492bf14a54594835ba0faac91f84b4f5d81460
      `web3.eth.getStorageAt("0x2890b9494a202F2D537Beb65E6100a8899E165a1", "0xeddb6698d7c569ff62ff64f1f1492bf14a54594835ba0faac91f84b4f5d81460")`
      Output => '0x46' -> 70 in decimal
    
    3. ab[0x7a02f64Cfe9a38a4ecFe4A91601aB789c1bFeb94]
      location for aa[4] = keccak256(0x0000000000000000000000007a02f64Cfe9a38a4ecFe4A91601aB789c1bFeb940000000000000000000000000000000000000000000000000000000000000006)
                        = 0x84d93e274c0e77176bc83245f84088aba339fe46f5e1cb36896b98c667cd33a1
      `web3.eth.getStorageAt("0x2890b9494a202F2D537Beb65E6100a8899E165a1", "0x84d93e274c0e77176bc83245f84088aba339fe46f5e1cb36896b98c667cd33a1")`
      Output => '0x64' -> 100 in decimal
  */


  /**
    After deploying the contract to the Ganache Network and getting the storage from contract address at slot 0
  
    truffle(development)> const instance = await Storage.deployed()
    truffle(development)> web3.eth.getStorageAt(instance.address, 0)
    Output: 0x0f01648faad551af1da6d6556f0e3c41b37b6055bad1000a07
    Dissecting it from right side, for varaibles value from top, according to size of bytes:
    0x 0f 01 648faad551af1da6d6556f0e3c41b37b6055bad1 000a 07

    truffle(development)> web3.eth.getStorageAt(instance.address, 1)
    Dissected Output: 0x c8 -> hexadecimal value for 200 i.e. uint256 public f = 200

    truffle(development)> web3.eth.getStorageAt(instance.address, 2)
    Dissected Output: 0x 28 -> hexadecimal value for 40 i.e. uint8 public g = 40

    truffle(development)> web3.eth.getStorageAt(instance.address, 3)
    Dissected Output: 0x 0315 -> hexadecimal value for 789 i.e. uint256 public h = 789
   */

}
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
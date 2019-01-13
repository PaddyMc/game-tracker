/**
    @title: GameTrackerInterface
    @dev: game tracker contract to store IPFS locations
    @author: PaddyMc
 */

pragma solidity ^0.5.0;

/**
    an interface for tracking game uploads and funders
**/
contract GameTrackerInterface {
/**
    Games
**/
//   function getOwner() public view returns (address);

  function upload(string memory ipfsHash, string memory newGameStateLocation) public;

  function getHashByNum(uint position) public view returns (string memory);

  function getOwnerForGame(uint position) public view returns (address, uint);

  function getAccountForGame(string memory ipfsHash) public view returns (address, uint);

  function getNumberOfHashes() public view returns (uint);

  function getIPFSHashForOwner(address ownerAddress, uint number) public view returns (string memory);

  function getTotalGamesForOwner(address ownerAddress) public view returns (uint);

/**
    Funders
**/
//   function fundGameOwner(string memory ipfsHash) public payable;

//   function getNumberOfFunders() public view returns (uint256);

//   function getTotalAmountFunded() public view returns (uint);

//   function getAmountFundedByAddress(address funderAddress) public view returns (uint);

//   function getAllFundersForGame(string memory ipfsHash) public view returns (address[] memory);

//   function getFunderAddressByNum(uint position) public view returns (address);

//   function getFunderDataByNum(uint position) public view returns (address, uint);
}
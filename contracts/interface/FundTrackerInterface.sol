pragma solidity ^0.5.0;

contract FundTrackerInterface {
/**
    Funders
**/
  function fundGameOwner(string memory ipfsHash) public payable;

  function getNumberOfFunders() public view returns (uint256);

  function getTotalAmountFunded() public view returns (uint);

  function getAmountFundedByAddress(address funderAddress) public view returns (uint);

  function getAllFundersForGame(string memory ipfsHash) public view returns (address[] memory);

  function getFunderAddressByNum(uint position) public view returns (address);

  function getFunderDataByNum(uint position) public view returns (address, uint);
}
/**
    @title: GameTrackerInterface
    @dev: game tracker contract to store IPFS locations
    @author: PaddyMc
 */

pragma solidity ^0.4.24;

/**
    an interface for tracking game uploads and funders
**/
contract GameTrackerInterface {
    /**
      Games
    **/
    function getOwner() public view returns (address);
    
    function upload(string ipfsHash) public;

    function getHashByNum(uint position) public view returns (string);

    function getOwnerForGame(uint position) public view returns (address, uint);

    function getAccountForGame(string ipfsHash) public view returns (address, uint);

    function getNumberOfHashes() public view returns (uint);

    function getIPFSHashForOwner(address ownerAddress, uint number) public view returns (string);

    function getTotalGamesForOwner(address ownerAddress) public view returns (uint);

    /**
      Funders
    **/
    function fundGameOwner(string ipfsHash) public payable;

    function getNumberOfFunders() public view returns (uint256);

    function getTotalAmountFunded() public view returns (uint);

    function getAmountFundedByAddress(address funderAddress) public view returns (uint);

    function getAllFundersForGame(string ipfsHash) public view returns (address[]);

    function getFunderAddressByNum(uint position) public view returns (address);

    function getFunderDataByNum(uint position) public view returns (address, uint);
}
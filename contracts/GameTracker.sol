/**
  @title: GameTracker
  @dev: game tracker contract to store IPFS locations
  @author: PaddyMc
 */

pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./interface/GameTrackerInterface.sol";

/**
  a base contract for tracking game uploads and funders
**/
contract GameTracker is GameTrackerInterface {

  using SafeMath for uint;

  address owner;
  string gameStateLocation;

  event Uploaded(string ipfsHash);
  
  struct GameData {
    address payable owner;
    uint amountFunded;
  }

  // Game Data
  mapping(uint => string) mapGameData;
  mapping(string => GameData) fullGameData;
  mapping(address => string[]) gameOwnerData;
  
  uint numberOfGames = 0;
  
  /**
    Games
  **/
  function upload(string memory ipfsHash, string memory newGameStateLocation) public {
    require(bytes(ipfsHash).length == 46, "incorrect length");
    require(fullGameData[ipfsHash].owner == address(0x0), "game already uploaded");

    gameOwnerData[msg.sender].push(ipfsHash);
    fullGameData[ipfsHash].owner = msg.sender;
    fullGameData[ipfsHash].amountFunded = 0;
    mapGameData[numberOfGames] = ipfsHash;
    numberOfGames++;

    setGameStateLocation(newGameStateLocation);
     
    emit Uploaded(ipfsHash);
  }

  function getHashByNum(uint position) public view returns (string memory) {
    return mapGameData[position];
  }

  function getOwnerForGame(uint position) public view returns (address, uint) {
    return (fullGameData[mapGameData[position]].owner, fullGameData[mapGameData[position]].amountFunded);
  }

  function getAccountForGame(string memory ipfsHash) public view returns (address, uint) {
    return (fullGameData[ipfsHash].owner, fullGameData[ipfsHash].amountFunded);
  }

  function getNumberOfHashes() public view returns (uint) {
    return numberOfGames;
  }

  function getIPFSHashForOwner(address ownerAddress, uint number) public view returns (string memory){
    return gameOwnerData[ownerAddress][number];
  }

  function getTotalGamesForOwner(address ownerAddress) public view returns (uint){
    return gameOwnerData[ownerAddress].length;
  }

  /**
    GameState
  **/
  function setGameStateLocation(string memory newLocation) internal {
    gameStateLocation = newLocation;
  }

  function getGameStateLocation() public view returns (string memory){
    return gameStateLocation;
  }


}
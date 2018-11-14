/**
    @title: GameTracker
    @dev: game tracker contract to store IPFS locations
    @author: PaddyMc
 */

pragma solidity ^0.4.24;

import "./lib/math.sol";

/**
    a base contract for tracking game uploads and funders
**/
contract GameTracker {

    using DSMath for uint;

    address owner;

    event Uploaded(string ipfsHash);
    event UpdatedBalance(address addressFunded, uint balanceETH);

    constructor() public {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
    
    struct GameData {
        address owner;
        uint amountFunded;
    }

    // Game Data
    mapping(uint => string) mapGameData;
    mapping(string => GameData) fullGameData;
    mapping(address => string[]) gameOwnerData;
    
    // Funding Data
    mapping(uint => address) mapFundedData;
    mapping(address => uint) funderFundedData;
    mapping(string => address[]) ipfsHashFunded;

    uint numberOfGames = 0;
    uint numberOfFunders = 0;
    uint totalETH = 0;

    /**
        Games
    **/
    function upload(string ipfsHash) public {
        require(bytes(ipfsHash).length == 46, "incorrect length");

        gameOwnerData[msg.sender].push(ipfsHash);
        fullGameData[ipfsHash].owner = msg.sender;
        fullGameData[ipfsHash].amountFunded = 0;
        mapGameData[numberOfGames] = ipfsHash;
        numberOfGames++;
       
        emit Uploaded(ipfsHash);
    }

    function getHashByNum(uint position) public view returns (string) {
        return mapGameData[position];
    }

    function getOwnerForGame(uint position) public view returns (address) {
        return fullGameData[mapGameData[position]].owner;
    }

    function getAccountForGame(uint position) public view returns (address, uint) {
        return (fullGameData[mapGameData[position]].owner, fullGameData[mapGameData[position]].amountFunded);
    }

    function getNumberOfHashes() public view returns (uint) {
        return numberOfGames;
    }

    function getIPFSHashForOwner(address ownerAddress, uint number) public view returns (string){
        return gameOwnerData[ownerAddress][number];
    }

    function getTotalGamesForOwner(address ownerAddress) public view returns (uint){
        return gameOwnerData[ownerAddress].length;
    }

    /**
        Funders
    **/
    function fundGameOwner(string ipfsHash) public payable {
        require(msg.sender.balance >= msg.value, "not enough funds");
        
        if(getAmountFundedByAddress(msg.sender) != 0){
            funderFundedData[msg.sender] = funderFundedData[msg.sender].add(msg.value);
            ipfsHashFunded[ipfsHash].push(msg.sender);
            totalETH = totalETH.add(msg.value);
            emit UpdatedBalance(msg.sender, funderFundedData[msg.sender]);
        } else {
            funderFundedData[msg.sender] = msg.value;
            ipfsHashFunded[ipfsHash].push(msg.sender);
            mapFundedData[numberOfFunders] = msg.sender;
            totalETH = totalETH.add(msg.value);
            numberOfFunders++;

            emit UpdatedBalance(msg.sender, funderFundedData[msg.sender]);
        }
        fullGameData[ipfsHash].amountFunded = fullGameData[ipfsHash].amountFunded.add(msg.value);
        fullGameData[ipfsHash].owner.transfer(msg.value);

        emit UpdatedBalance(fullGameData[ipfsHash].owner, fullGameData[ipfsHash].amountFunded);
    }

    function getNumberOfFunders() public view returns (uint256) {
        return numberOfFunders;
    }

    function getTotalAmountFunded() public view returns (uint) {
        return totalETH;
    }

    function getAmountFundedByAddress(address funderAddress) public view returns (uint) {
        return funderFundedData[funderAddress];
    }

    function getAllFundersForGame(string ipfsHash) public view returns (address[]) {
        return ipfsHashFunded[ipfsHash];
    }

    function getFunderAddressByNum(uint position) public view returns (address) {
        return mapFundedData[position];
    }

    function getFunderDataByNum(uint position) public view returns (address, uint) {
        return (mapFundedData[position], funderFundedData[mapFundedData[position]]);
    }
}
/**
    @title: GameTracker
    @dev: game tracker contract to store IPFS locations
    @author: PaddyMc
 */

pragma solidity ^0.4.24;

import "./Accounting.sol";
import "./lib/math.sol";

/**
 a base contract for tracking game uploads and funders
 */
contract GameTracker is Accounting {
    address owner;

    event Uploaded(string ipfsHash);

    constructor() public{
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
    
    struct GameData {
        Account account;
        address owner;
        string ipfsHash;
    }

    struct Funder {
        Account account;
        address funder;
    }

    mapping(uint => GameData) allGameData;
    mapping(uint => Funder) funders;
    uint numberOfGames = 0;
    uint numberOfFunders = 0;

    function upload(string ipfsHash, bytes32 name) public returns (string) {
        require(bytes(ipfsHash).length == 46, "incorrect length");

        Account memory init = Account({
            name: name,
            balanceETH: 0       
        });

        GameData memory gamedata = GameData(init, msg.sender, ipfsHash);
        allGameData[numberOfGames] = gamedata;
        numberOfGames++;
       
        emit Uploaded(ipfsHash);
    }

    function getHashByNum(uint position) public view returns (string) {
        GameData memory gamedata = allGameData[position];
        return gamedata.ipfsHash;
    }

    function getNumberOfHashes() public view returns (uint) {
        return numberOfGames;
    }

    function getOwnerForGame(uint position) public view returns (address) {
        GameData memory gamedata = allGameData[position];
        return gamedata.owner;
    }

    function getAccountForGame(uint position) public view returns (bytes32, uint) {
        GameData memory gamedata = allGameData[position];
        return (gamedata.account.name, gamedata.account.balanceETH);
    }

    // ToDo: function getAllGamesForOwner

    function fundGameOwner(uint position) public payable returns (address) {
        require(msg.sender.balance >= msg.value, "not enough funds");
        GameData memory gamedata = allGameData[position];
        (Funder memory fun, bool isFunder) = _hasFundingAccount(msg.sender);

        if(isFunder){
            fun.account.balanceETH.add(msg.value);
        } else {
            Account memory init = Account({
                name: "temp",
                balanceETH: 0
            });

            Funder memory funder = Funder(init, msg.sender);
            funders[numberOfFunders] = funder;
            numberOfFunders++;
        }
        gamedata.owner.transfer(msg.value);
        depositETH(gamedata.account, msg.sender, msg.value);
    }

    function getTotalAmountFunded() public view returns (uint){
        return totalETH;
    }

    function getTopFunder() public view returns (address) {
        uint topFunds = 0;
        address topFunder;
        for(uint i = 0; i < numberOfFunders; i++){
            if(funders[i].account.balanceETH > topFunds){
                topFunds = funders[i].account.balanceETH;
                topFunder = funders[i].funder;
            }
        }
        return topFunder;
    }

    function _hasFundingAccount(address funderAc) internal view returns(Funder memory, bool){
        for(uint i = 0; i < numberOfFunders; i++){
            if(funders[i].funder == funderAc) {
                return(funders[i], true);
            } else {
                Funder memory notfun;
                return(notfun, false);
            }
        }
    }

    function getNumberOfFunders() public view returns (uint) {
        return numberOfFunders;
    }
}
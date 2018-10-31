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
**/
contract GameTracker is Accounting {
    address owner;

    event Uploaded(string ipfsHash);
    event UpdatedBalance(address addressFunded, uint balanceETH);
    event TopFunder(address topFunder, uint topFunds);
    // event TransferOwnership(address orginalOwner, address newOwner);

    constructor() public {
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

    /**
        Games
    **/
    function upload(string ipfsHash, bytes32 name) public {
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
    // ToDo
    // function getAllGamesForOwner(address multipleOwnerAddress) public view returns (string){

    // }

    // function transferOwnership(uint position) public payable {
    //     require(msg.sender.balance >= msg.value, "not enough funds");
    //     GameData storage gamedata = allGameData[position];
    //     gamedata.owner.transfer(msg.value);
    //     address orginalOwner = gamedata.owner;
    //     gamedata.owner = msg.sender;

    //     emit TransferOwnership(orginalOwner, msg.sender);
    // }

    /**
        Funders
    **/
    function getFunderAddressByNum(uint position) public view returns (address) {
        Funder memory funder = funders[position];
        return funder.funder;
    }

    function getNumberOfFunders() public view returns (uint) {
        return numberOfFunders;
    }

    function getTotalAmountFunded() public view returns (uint){
        return totalETH;
    }

    function fundGameOwner(uint position) public payable {
        require(msg.sender.balance >= msg.value, "not enough funds");
        GameData storage gamedata = allGameData[position];
        (Funder memory newFunder, Funder storage fun, bool isFunder) = _hasFundingAccount(msg.sender);

        if(isFunder){
            fun.account.balanceETH = fun.account.balanceETH.add(msg.value);
            emit UpdatedBalance(fun.funder, fun.account.balanceETH);
        } else {
            Account memory init = Account({
                name: "temp",
                balanceETH: 0
            });

            newFunder = Funder(init, msg.sender);
            newFunder.account.balanceETH = newFunder.account.balanceETH.add(msg.value);
            emit UpdatedBalance(newFunder.funder, newFunder.account.balanceETH);
            funders[numberOfFunders] = newFunder;
            numberOfFunders++;
        }
        gamedata.owner.transfer(msg.value);
        
        depositETH(gamedata.account, msg.sender, msg.value);
        emit UpdatedBalance(gamedata.owner, gamedata.account.balanceETH);
    }

    function getTopFunder() public view returns (address, uint){
        uint topAmountFunded = 0;
        address topFunder;
        for(uint i = 0; i < numberOfFunders; i++){
            if(funders[i].account.balanceETH > topAmountFunded){
                topAmountFunded = funders[i].account.balanceETH;
                topFunder = funders[i].funder;
            }
        }
        //emit TopFunder(topFunder, topFunds);
        return (topFunder, topAmountFunded);
    }

    function _hasFundingAccount(address funderAccount) private view returns(Funder memory, Funder storage, bool){
        Funder memory funderMemory;
        Funder storage funderStorage;
        bool isFunder = false;
        for(uint i = 0; i < numberOfFunders; i++){
            if(getFunderAddressByNum(i) == funderAccount) {
                funderStorage = funders[i];
                isFunder = true;
                return(funderMemory, funderStorage, isFunder);
            }
        }
        return(funderMemory, funderStorage, isFunder);
    }
}
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

    mapping(address => string[]) gameOwnerData;
    mapping(address => uint) funderFundedData;
    mapping(string => address[]) ipfsHashFunded;

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
        gameOwnerData[msg.sender].push(ipfsHash);
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

    function getIPFSHashForOwner(address ownerAddress, uint number) public view returns (string){
        return gameOwnerData[ownerAddress][number];
    }

    function getTotalGamesForOwner(address ownerAddress) public view returns (uint){
        return gameOwnerData[ownerAddress].length;
    }

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
    function fundGameOwner(uint position) public payable {
        require(msg.sender.balance >= msg.value, "not enough funds");
        GameData storage gamedata = allGameData[position];
        
        if(getAmountFundedByAddress(msg.sender) != 0){
            Funder storage funder = _getFunder(msg.sender);
            funder.account.balanceETH = funder.account.balanceETH.add(msg.value);
            funderFundedData[funder.funder] = funderFundedData[funder.funder].add(msg.value);
            ipfsHashFunded[gamedata.ipfsHash].push(funder.funder);
            emit UpdatedBalance(funder.funder, funder.account.balanceETH);
        } else {
            Account memory init = Account({
                name: "temp",
                balanceETH: 0
            });

            Funder memory newFunder = Funder(init, msg.sender);
            newFunder.account.balanceETH = newFunder.account.balanceETH.add(msg.value);
            funderFundedData[newFunder.funder] = msg.value;
            ipfsHashFunded[gamedata.ipfsHash].push(newFunder.funder);

            emit UpdatedBalance(newFunder.funder, newFunder.account.balanceETH);
            funders[numberOfFunders] = newFunder;
            numberOfFunders++;
        }
        gamedata.owner.transfer(msg.value);
        
        depositETH(gamedata.account, msg.sender, msg.value);
        emit UpdatedBalance(gamedata.owner, gamedata.account.balanceETH);
    }

    function getFunderAddressByNum(uint position) public view returns (address) {
        Funder memory funder = funders[position];
        return funder.funder;
    }

    function getFunderDataByNum(uint position) public view returns (address, uint) {
        Funder memory funder = funders[position];
        return (funder.funder, funder.account.balanceETH);
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

    function getTopFunder() public view returns (address, uint) {
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

    function _getFunder(address funderAccount) internal view returns(Funder storage) {
        for(uint i = 0; i < numberOfFunders; i++){
            if(getFunderAddressByNum(i) == funderAccount) {
                Funder storage funderStorage = funders[i];
                return(funderStorage);
            }else{
                Funder storage funderStorageExit = funders[0];
                return funderStorageExit;
            }
        }
        Funder storage funderStorageFix = funders[0];
        return funderStorageFix;
    }
}
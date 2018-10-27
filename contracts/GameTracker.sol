pragma solidity ^0.4.23;

contract GameTracker {
    // Learn events
    address owner;

    constructor() public{
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
    
    struct GameData {
        address owner;
        string ipfsHash;
    }

    mapping(uint => GameData) allGameData;
    uint number = 0;

    function upload(string ipfsHash) public returns (string) {
        require(bytes(ipfsHash).length == 46, "correct lenght");
        GameData memory gamedata = GameData(msg.sender, ipfsHash);
        allGameData[number] = gamedata;
        number++;
       
        return ipfsHash;
    }

    function getHashByNum(uint position) public view returns (string) {
        GameData memory gamedata = allGameData[position];
        return gamedata.ipfsHash;
    }

    function getNumberOfHashes() public view returns (uint) {
        return number;
    }

    function getOwnerForGame(uint position) public view returns (address) {
        GameData memory gamedata = allGameData[position];
        return gamedata.owner;
    }

    // function getAllHashes() public view returns (bytes32[] memory) {
    //     bytes32[] memory hope;
    //     for ( uint i = 0; i < number; i++ ) {
    //         hope[number] = bytes32(allGameData[i].ipfsHash);
    //     }
    //     return hope; 
    // }
}
pragma solidity ^0.4.23;

contract GameTracker {

    struct GameData {
        address owner;
        bytes32 ipfsHash;
    }

    mapping(uint256 => GameData) allGameData;
    uint256 number = 0;

    function upload(bytes32 ipfsHash) public returns (bytes32) {
        //require(ipfsHash=> validate);
        GameData memory gamedata = GameData(msg.sender, ipfsHash);
        allGameData[number] = gamedata;
        number++;
       
        return ipfsHash;
    }

    function getHashByNum(uint256 position) public returns (bytes32) {
        //require(ipfsHash=> validate);
        GameData storage gamedata = allGameData[position];

        log0(gamedata.ipfsHash);
        return gamedata.ipfsHash;
    }

    function getNumberOfHashes() public returns (uint256) {
        log0("asd");
        return number;
    }

    // function getAllHashes() public returns (bytes32[]) {
    //     log0("asd");
    //     bytes32[] memory hope;
    //     for ( uint i = 0; i < number; i++ ) {
    //         hope.push(allGameData[i].ipfsHash);
    //     }
    //     return hope; 
    // }
}
pragma solidity ^0.4.23;

contract GameTracker {

    struct GameData {
        address owner;
        string ipfsHash;
    }

    mapping(uint256 => GameData) allGameData;
    uint256 number = 0;

    function upload(string ipfsHash) public returns (string) {
        //require(ipfsHash=> validate);
        GameData memory gamedata = GameData(msg.sender, ipfsHash);
        allGameData[number] = gamedata;
        number++;
       
        return ipfsHash;
    }

    function getHashByNum(uint256 position) public view returns (string) {
        //require(ipfsHash=> validate);
        GameData storage gamedata = allGameData[position];
        return gamedata.ipfsHash;
    }

    function getNumberOfHashes() public view returns (uint256) {
        return number;
    }

    // function getAllHashes() public view returns (bytes32[]) {
    //     log0("asd");
    //     bytes32[] memory hope;
    //     for ( uint i = 0; i < number; i++ ) {
    //         hope.push(allGameData[i].ipfsHash);
    //     }
    //     return hope; 
    // }
}
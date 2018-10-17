pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GameTracker.sol";

contract TestGameTracker {
    GameTracker gameTracker = GameTracker(DeployedAddresses.GameTracker());

    function testUserUpload() public {
        bytes32 returned = gameTracker.upload("hope");
        bytes32 expected = "hope";
        Assert.equal(returned, expected, "added to smart contract");
    }

    function testGetAllHashes() public {
        gameTracker.upload("hope123");
        bytes32 returnedHash = gameTracker.getHashByNum(1);
        bytes32 expected = "hope123";
        Assert.equal(returnedHash, expected, "stored in the correct place in array");
    }

    function testTotalHashes() public {
        uint256 numberOfHashes = gameTracker.getNumberOfHashes();
        uint256 expected = 2;
        Assert.equal(numberOfHashes, expected, "equal 2");
    }
}
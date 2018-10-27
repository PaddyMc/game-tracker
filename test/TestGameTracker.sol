pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GameTracker.sol";

contract TestGameTracker {
    GameTracker gameTracker = GameTracker(DeployedAddresses.GameTracker());

    function testUserUpload() public {
        string memory returned = gameTracker.upload("QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd");
        string memory expected = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd";
        Assert.equal(returned, expected, "added to smart contract");
    }

    function testGetAllHashes() public {
        gameTracker.upload("Qm2XgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd");
        string memory returnedHash = gameTracker.getHashByNum(1);
        string memory expected = "Qm2XgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd";
        Assert.equal(returnedHash, expected, "stored in the correct place in array");
    }

    function testTotalHashes() public {
        uint numberOfHashes = gameTracker.getNumberOfHashes();
        uint expected = 2;
        Assert.equal(numberOfHashes, expected, "equal 2");
    }
}
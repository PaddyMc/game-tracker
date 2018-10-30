pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GameTracker.sol";

contract TestGameTracker {
    GameTracker gameTracker = GameTracker(DeployedAddresses.GameTracker());

    function testUserUpload() public {
        gameTracker.upload("QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd", "Paddy");
        uint numberOfHashes = gameTracker.getNumberOfHashes();
        uint expected = 1;
        Assert.equal(numberOfHashes, expected, "added to smart contract");
    }

    function testGetHashByNum() public {
        gameTracker.upload("Qm2XgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd", "Paddy");
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
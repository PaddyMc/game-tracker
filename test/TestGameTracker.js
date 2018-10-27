var Gametracker = artifacts.require("../contracts/GameTracker.sol");

contract('Gametracker', function(accounts) {
    var admin = accounts[0];

    var gametracker;
    var ipfsHash = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd"

    beforeEach(async () => {
        gametracker = await Gametracker.new();
        await gametracker.upload(ipfsHash)
    })

    it("creates with owner", async function () {
        assert.equal(await gametracker.getOwner.call(), admin, "owner is added");
    });
    
    it("uploads an ipfs hash for a game", async function () {
        const numberOfGames = await gametracker.getNumberOfHashes()
        assert.equal(numberOfGames, 1, "ipfs hash for game has been added");
    });

    it("checks ipfs hash is uploaded", async function () {
        const ipfsHashByNum = await gametracker.getHashByNum(0)
        assert.equal(ipfsHashByNum, ipfsHash, "game owner owns ipfs hash");
    });
    
    it("checks game owner is correct", async function () {
        const gameOwner = await gametracker.getOwnerForGame(0)
        assert.equal(gameOwner, admin, "game owner owns ipfs hash");
    });
});
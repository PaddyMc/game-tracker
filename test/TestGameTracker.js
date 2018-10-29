var Gametracker = artifacts.require("../contracts/GameTracker.sol");

contract('Gametracker', function(accounts) {
    var admin = accounts[0];
    var funder = accounts[1];

    var gametracker;
    var validIpfsHash = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd"
    var name = "Paddy"

    var arbitraryAmount = 100000000;

    beforeEach(async () => {
        gametracker = await Gametracker.new()
        await gametracker.upload(validIpfsHash, name)
    })

    it("uploads a game and stores a hash", async function () {
        var upload = await gametracker.upload(validIpfsHash, name)
        assert.equal(upload.logs[0].args.ipfsHash, validIpfsHash, "owner is added")
    });

    it("creates with owner", async function () {
        assert.equal(await gametracker.getOwner.call(), admin, "owner is added")
    });
    
    it("uploads an ipfs hash for a game", async () => {
        const numberOfGames = await gametracker.getNumberOfHashes()
        assert.equal(numberOfGames, 1, "ipfs hash for game has been added")
    });

    it("checks ipfs hash is uploaded", async () => {
        const ipfsHashByNum = await gametracker.getHashByNum(0)
        assert.equal(ipfsHashByNum, validIpfsHash, "game owner owns ipfs hash")
    });
    
    it("checks game owner is correct", async () => {
        const gameOwner = await gametracker.getOwnerForGame(0)
        assert.equal(gameOwner, admin, "game owner owns ipfs hash")
    });

    it("checks game account is correct", async () => {
        const gameAccount = await gametracker.getAccountForGame(0)
        console.log(gameAccount[0])
        console.log(gameAccount[1].toString())
    });

    it("funders", async () => {
        //ToDo: Finish tests
        const tip = 100000000000000000;
        const pit = 1000000000000;
        console.log(admin)
        console.log(funder)
        const gameAccount = await gametracker.fundGameOwner(0, {from:funder, value: tip})
        await gametracker.fundGameOwner(0, {from:funder, value: tip})
        await gametracker.fundGameOwner(0, {from:admin, value: pit})
        const numberOfFunders = await gametracker.getNumberOfFunders()
        const totalAmountFunded = await gametracker.getTotalAmountFunded()
        const topFunder = await gametracker.getTopFunder()
        console.log(funder, topFunder)
        console.log(totalAmountFunded.toString())
        console.log(numberOfFunders.toString())
        //console.log(gameAccount)
        //assert.equal(gameOwner, admin, "game owner owns ipfs hash")
    });
});
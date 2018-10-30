var Gametracker = artifacts.require("../contracts/GameTracker.sol");

contract('Gametracker', function(accounts) {
    var admin = accounts[0];
    var funder = accounts[1];
    var funderInit = accounts[2];
    var funderTwo = accounts[3];

    var gametracker;
    var validIpfsHash = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd"
    var name = "Paddy"

    var arbitraryAmount = 100000000;
    var arbitraryAmount2 = 200000000;
    var arbitraryAmount3 = 300000000;

    beforeEach(async () => {
        gametracker = await Gametracker.new()
        await gametracker.upload(validIpfsHash, name, {from:admin})
        await gametracker.fundGameOwner(0, {from:funderInit, value: arbitraryAmount})
    })

    it("uploads a game and stores a hash", async function () {
        var upload = await gametracker.upload(validIpfsHash, name)
        assert.equal(upload.logs[0].args.ipfsHash, validIpfsHash, "Upload event returned incorrect hash")
    });

    it("creates with owner", async function () {
        assert.equal(await gametracker.getOwner.call(), admin, "owner is not added")
    });
    
    it("uploads an ipfs hash for a game", async () => {
        const numberOfGames = await gametracker.getNumberOfHashes()
        assert.equal(numberOfGames, 1, "ipfs hash for game has not been added")
    });

    it("checks ipfs hash is uploaded", async () => {
        const ipfsHashByNum = await gametracker.getHashByNum(0)
        assert.equal(ipfsHashByNum, validIpfsHash, "ipfs hash is incorrect")
    });
    
    it("checks game owner is correct", async () => {
        const gameOwner = await gametracker.getOwnerForGame(0)
        assert.equal(gameOwner, admin, "game owner does not own ipfs hash")
    });

    it("checks game account is correct", async () => {
        const gameAccount = await gametracker.getAccountForGame(0)
        assert.equal(gameAccount[1].toString(), 100000000, "game account is incorrect")
    });

    // it("transfers ownership of the game", async () => {
    //     const transferOwnership = await gametracker.transferOwnership(0, {from:funderTwo, value:arbitraryAmount})
    //     const gameOwner = await gametracker.getOwnerForGame(0)
    //     assert.equal(transferOwnership.logs[0].args.newOwner, gameOwner, "ownership did not transfer")
    //     assert.notEqual(transferOwnership.logs[0].args.orginalOwner, gameOwner, "ownership did not transfer")
    // });

    it("funds a game", async () => {
        const gameAccount = await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount})
        assert.equal(gameAccount.logs[1].args.from, funder, "incorrect funder")
        assert.equal(gameAccount.logs[1].args.value.toString(), arbitraryAmount, "incorrect amount funded")
    });

    it("funds two games and ensures total is correct",  async () => {
        await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount})
        await gametracker.fundGameOwner(0, {from:admin, value: arbitraryAmount2})
        const totalAmountFunded = await gametracker.getTotalAmountFunded()
        const totalFunded = arbitraryAmount+arbitraryAmount+arbitraryAmount2
        assert.equal(totalAmountFunded.toString(), totalFunded, "total funded incorrect")
    });

    it("two funders fund two games with one repetition and are recorded correctly",  async () => {
        await gametracker.upload(validIpfsHash, name)
        await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount})
        await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount2})
        const numberOfFunders = await gametracker.getNumberOfFunders()
        assert.equal(numberOfFunders.toString(), 2, "duplicate funders")
    });

    it("balance of game uploader has been recorded",  async () => {
        await gametracker.upload(validIpfsHash, name)
        await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount})
        await gametracker.fundGameOwner(0, {from:funder, value: arbitraryAmount})
        await gametracker.fundGameOwner(0, {from:funderTwo, value: arbitraryAmount2})
        const eventUpdatedBalance = await gametracker.fundGameOwner(0, {from:admin, value: arbitraryAmount3})

        const numberOfFunders = await gametracker.getNumberOfFunders()
        assert.equal(numberOfFunders.toString(), 4, "duplicate funders")
        
        const amountFunded = (arbitraryAmount*3)+arbitraryAmount2+arbitraryAmount3
        assert.equal(eventUpdatedBalance.logs[2].args.balanceETH.toString(), amountFunded, "accounts funds update incorrectly")
    });

    it("ensures top funder is correct",  async () => {
        await gametracker.fundGameOwner(0, {from:funderInit, value: arbitraryAmount})
        const topFunder = await gametracker.getTopFunder()
        assert.equal(topFunder.logs[0].args.topFunder, funderInit, "incorrect top funder")
        assert.equal(topFunder.logs[0].args.topFunds, arbitraryAmount*2, "incorrect amount funded")
    });
});
var Gametracker = artifacts.require("../contracts/GameTracker.sol");

contract('Gametracker', function(accounts) {
  var admin = accounts[0];
  var funder = accounts[1];
  var funderInit = accounts[2];
  var funderTwo = accounts[3];

  var gameUploader = accounts[4]

  var madman = accounts[5]

  var gametracker;
  var validIpfsHash = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFSha"
  var validIpfsHash2 = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShb"
  var validIpfsHash3 = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShc"
  var validIpfsHash4 = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShd"
  var validIpfsHash5 = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShe"

  var validIpfsHashSearchLocation = "QmPXgPCzbdviCVJTJxvYCWtMuRWCKRfNRVcSpARHDKFShS"

  var arbitraryAmount = 100000000;
  var arbitraryAmount2 = 200000000;
  var arbitraryAmount3 = 300000000;

  beforeEach(async () => {
    gametracker = await Gametracker.new()
    await gametracker.upload(validIpfsHash, validIpfsHashSearchLocation, {from:admin})
    //await gametracker.fundGameOwner(validIpfsHash, {from:funderInit, value: arbitraryAmount})
  })

  it("uploads a game and stores a hash", async function () {
    var upload = await gametracker.upload(validIpfsHash2,  validIpfsHashSearchLocation,)
    assert.equal(upload.logs[0].args.ipfsHash, validIpfsHash2, "Upload event returned incorrect hash")
  });

  // it("creates with owner", async function () {
  //   assert.equal(await gametracker.getOwner.call(), admin, "owner is not added")
  // });
  
  it("uploads an ipfs hash for a game", async () => {
    const numberOfGames = await gametracker.getNumberOfHashes()
    assert.equal(numberOfGames, 1, "ipfs hash for game has not been added")
  });

  // it("uploads a game that is already present", async () => {
  //   await gametracker.upload(validIpfsHash, {from:admin})

  //   //assert.equal(numberOfGames, 1, "ipfs hash for game has not been added")
  // });

  // it("gets the ipfs hash by owner", async () => {
  //   const ownedIPFSHash = await gametracker.getIPFSHashForOwner(admin, 0)
  //   assert.equal(ownedIPFSHash, validIpfsHash, "ipfs hash is incorrect")
  // });

  it("gets multiple ipfs hashs by owner", async () => {
    await gametracker.upload(validIpfsHash2, validIpfsHashSearchLocation, {from:gameUploader})
    let numberOfGamesOwner = await gametracker.getTotalGamesForOwner(gameUploader)
    assert.equal(numberOfGamesOwner.toString(), 1, "incorrect amount of games owned")
    await gametracker.upload(validIpfsHash3, validIpfsHashSearchLocation, {from:gameUploader})
    numberOfGamesOwner = await gametracker.getTotalGamesForOwner(gameUploader)
    assert.equal(numberOfGamesOwner.toString(), 2, "incorrect amount of games owned")

    const ownedIPFSHash = await gametracker.getIPFSHashForOwner(gameUploader, 0)
    const ownedIPFSHash2 = await gametracker.getIPFSHashForOwner(gameUploader, 1)
    assert.equal(ownedIPFSHash, validIpfsHash2, "ipfs hash is incorrect")
    assert.equal(ownedIPFSHash2, validIpfsHash3, "ipfs hash is incorrect")

  });

  it("checks ipfs hash is uploaded", async () => {
    const ipfsHashByNum = await gametracker.getHashByNum(0)
    assert.equal(ipfsHashByNum, validIpfsHash, "ipfs hash is incorrect")
  });
  
  it("checks game owner is correct", async () => {
    const gameOwner = await gametracker.getOwnerForGame(0)
    assert.equal(gameOwner[0], admin, "game owner does not own ipfs hash")
  });

  // it("checks game account is correct", async () => {
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funderInit, value: arbitraryAmount2})
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funderInit, value: arbitraryAmount3})
  //   const gameAccount = await gametracker.getAccountForGame(validIpfsHash)
  //   assert.equal(gameAccount[1].toString(), 600000000, "game account is incorrect")
  // });

  // it("funds a game", async () => {
  //   const gameAccount = await gametracker.fundGameOwner(validIpfsHash, {from:funder, value: arbitraryAmount})
  //   assert.equal(gameAccount.logs[1].args.addressFunded, admin, "incorrect account funded")
  //   assert.equal(gameAccount.logs[1].args.balanceETH.toString(), arbitraryAmount2, "incorrect amount funded")
  // });

  // it("funds two games and ensures total is correct",  async () => {
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funder, value: arbitraryAmount})
  //   await gametracker.fundGameOwner(validIpfsHash2, {from:admin, value: arbitraryAmount2})
  //   const totalAmountFunded = await gametracker.getTotalAmountFunded()
  //   const totalFunded = arbitraryAmount+arbitraryAmount+arbitraryAmount2
  //   assert.equal(totalAmountFunded.toString(), totalFunded, "total funded incorrect")
  // });

  // it("two funders fund two games with one repetition and are recorded correctly",  async () => {
  //   await gametracker.upload(validIpfsHash2, validIpfsHashSearchLocation)
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funder, value: arbitraryAmount})
  //   await gametracker.fundGameOwner(validIpfsHash2, {from:funder, value: arbitraryAmount2})
  //   const numberOfFunders = await gametracker.getNumberOfFunders()
  //   assert.equal(numberOfFunders.toString(), 2, "duplicate funders")
  // });

  // it("balance of game uploader has been recorded",  async () => {
  //   await gametracker.upload(validIpfsHash2, validIpfsHashSearchLocation)
  //   await gametracker.fundGameOwner(validIpfsHash2, {from:funder, value: arbitraryAmount})
  //   await gametracker.fundGameOwner(validIpfsHash2, {from:funder, value: arbitraryAmount})
  //   await gametracker.fundGameOwner(validIpfsHash2, {from:funderTwo, value: arbitraryAmount2})
  //   const eventUpdatedBalance = await gametracker.fundGameOwner(validIpfsHash2, {from:admin, value: arbitraryAmount3})

  //   const numberOfFunders = await gametracker.getNumberOfFunders()
  //   assert.equal(numberOfFunders.toString(), 4, "duplicate funders")
    
  //   const amountFunded = (arbitraryAmount*2)+arbitraryAmount2+arbitraryAmount3
  //   assert.equal(eventUpdatedBalance.logs[1].args.balanceETH.toString(), amountFunded, "accounts funds update incorrectly")
  // });
  
  // it("gets the amount funded by address", async () => {
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funderInit, value: arbitraryAmount})
  //   const amountFunded = await gametracker.getAmountFundedByAddress(funderInit)
  //   assert.equal(amountFunded.toString(), arbitraryAmount * 2, "incorrect total amount")
  // });

  // it("gets the funder data by number", async () => {
  //   const funderData = await gametracker.getFunderDataByNum(0)
  //   assert.equal(funderData[0], funderInit, "funder is incorrect")
  //   assert.equal(funderData[1], arbitraryAmount, "amount funded is incorrect")
  // });

  // it("gets the funder data by game location", async () => {
  //   let funderData = await gametracker.getAllFundersForGame(validIpfsHash)
  //   assert.equal(funderData[0], funderInit, "incorrect funder")
  //   await gametracker.fundGameOwner(validIpfsHash, {from:funder, value: arbitraryAmount})
  //   funderData = await gametracker.getAllFundersForGame(validIpfsHash)
  //   assert.equal(funderData[0], funderInit, "incorrect funder")
  //   assert.equal(funderData[1], funder, "incorrect funder")
  // });

  // it("uploads 1000 games like an absolute madman", async () => {
  //   for(let i = 0; i<1000; i++){
  //     let newValidIpfsHash
  //     if(i<10){
  //       newValidIpfsHash = validIpfsHash.substring(0, validIpfsHash.length - 1)
  //     } else if (i<100) {
  //       newValidIpfsHash = validIpfsHash.substring(0, validIpfsHash.length - 2)
  //     } else {
  //       newValidIpfsHash = validIpfsHash.substring(0, validIpfsHash.length - 3)
  //     }
      
  //     newValidIpfsHash = `${newValidIpfsHash}${i}`
  //     await gametracker.upload(newValidIpfsHash, validIpfsHashSearchLocation, {from:madman})
  //   }
  //   const numberOfGames = await gametracker.getNumberOfHashes()
  //   assert.equal(numberOfGames.toString(), 1001, "absolute madman didn't upload 1000 games")
  // })
});
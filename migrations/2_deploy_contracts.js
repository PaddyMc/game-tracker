var GameTracker = artifacts.require("./GameTracker.sol");
var FundTracker = artifacts.require("./FundTracker.sol");

module.exports = (deployer, network) => {
  console.log(`deployed on ${network} network`)
  deployer.deploy(GameTracker);
  deployer.deploy(FundTracker);
};
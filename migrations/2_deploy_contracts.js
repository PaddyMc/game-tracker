var GameTracker = artifacts.require("./GameTracker.sol");

module.exports = function(deployer) {
  deployer.deploy(GameTracker);
};
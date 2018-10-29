var Accounting = artifacts.require("./Accounting.sol");

module.exports = function(deployer) {
  deployer.deploy(Accounting);
};
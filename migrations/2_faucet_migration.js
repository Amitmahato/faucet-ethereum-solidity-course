const faucet = artifacts.require("Faucet");

module.exports = function (deployer) {
  deployer.deploy(faucet);
};

const Auction = artifacts.require("Auction");

module.exports = function (deployer) {
  deployer.deploy(Auction, 3600, "Luna", "Brandon's Cat", "84B");
};

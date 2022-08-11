const NFT = artifacts.require("NFT");
const NFTMarket = artifacts.require("NFTMarket");

module.exports = async(deployer)=> {
  await deployer.deploy(NFTMarket);
  let marketaddress = NFTMarket.address
  await deployer.deploy(NFT,marketaddress);
};

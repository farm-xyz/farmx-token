import { ethers, upgrades } from "hardhat";

async function main() {
  const FarmXToken = await ethers.getContractFactory("FarmXToken");
  const tokenProxy = await upgrades.deployProxy(FarmXToken);
  await tokenProxy.deployed();

  console.log("token deployed to: ", tokenProxy.address);

  // console.log("Lock with 1 ETH deployed to:", lock.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

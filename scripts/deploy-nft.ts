import { ethers, upgrades } from "hardhat";

async function main() {
  const FarmXNFTToken = await ethers.getContractFactory("FarmXNFTToken");
  const tokenProxy = await upgrades.deployProxy(FarmXNFTToken, [], { kind: "uups" });
  await tokenProxy.deployed();

  console.log("token deployed to: ", tokenProxy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

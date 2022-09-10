import { ethers, upgrades } from "hardhat";
import {FarmXTokenV1, FarmXTokenV2} from "../typechain-types";

async function main() {
  const oldFarmXToken = await ethers.getContractFactory("FarmXTokenV1");
  const oldTokenProxy = await upgrades.forceImport("0x4d84144b3f07E3E9B1B8853A86c1e3f502dceFe6", oldFarmXToken);

  const FarmXTokenFactory = await ethers.getContractFactory("FarmXTokenV2");
  const tokenProxy = await upgrades.upgradeProxy(oldTokenProxy, FarmXTokenFactory, {call: {fn: 'burnBridgeTokensAndUpdateDistribution'}});
  const farmXToken = (await tokenProxy.deployed()) as unknown as FarmXTokenV2;

  console.log("token upgraded to: ", tokenProxy.address);

  // console.log("Burning tokens for bridges");

  // await farmXToken.burnBridgeTokens();

  // console.log("Lock with 1 ETH deployed to:", lock.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

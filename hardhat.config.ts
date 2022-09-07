import { HardhatUserConfig } from "hardhat/config";
import * as dotenv from "dotenv";
import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomiclabs/hardhat-ethers";
import '@typechain/hardhat'
import "@nomiclabs/hardhat-etherscan";

dotenv.config({ path: __dirname+'/.env' });

const { POLYGON_MUMBAI_RPC_PROVIDER, POLYGON_RPC_PROVIDER, PRIVATE_KEY, POLYGONSCAN_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1
      },
    }
  },

  // defaultNetwork: "mumbai",
  networks: {
    polygon: {
      url: POLYGON_RPC_PROVIDER,
      accounts: [ `0x${PRIVATE_KEY}` ]
    },
    mumbai: {
      url: POLYGON_MUMBAI_RPC_PROVIDER,
      accounts: [ `0x${PRIVATE_KEY}` ]
    }
  },
  etherscan: {
    apiKey: {
      polygon: POLYGONSCAN_API_KEY as string,
      polygonMumbai: POLYGONSCAN_API_KEY as string
    },
  }
};

export default config;

import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "solidity-docgen";
import { accounts } from "./utils/network";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.9",

  networks: {
    matic: {
      url: "https://polygon-mainnet.infura.io/v3/69e9744c6cc845a38565011900d04b88",
      accounts: accounts("matic"),
    },
    mumbai: {
      url: "https://polygon-mumbai.infura.io/v3/69e9744c6cc845a38565011900d04b88",
      accounts: accounts("mumbai"),
      chainId: 80001,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.POLYGONSCAN_API_KEY,
      polygon: process.env.POLYGONSCAN_API_KEY,
    },
  },
  paths: {
    sources: "contracts",
  },
  docgen: {
    pages: "files",
  },
};

export default config;

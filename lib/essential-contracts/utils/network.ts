/* eslint-disable camelcase */
import "dotenv/config";
export function node_url(networkName: string): string {
  if (networkName) {
    const uri = process.env["ETH_NODE_URI_" + networkName.toUpperCase()];
    if (uri && uri !== "") {
      return uri;
    }
  }

  let uri = process.env.ETH_NODE_URI;
  if (uri) {
    uri = uri.replace("{{networkName}}", networkName);
  }
  if (!uri || uri === "") {
    if (networkName === "localhost") {
      return "http://localhost:8545";
    }
    // throw new Error(`environment variable "ETH_NODE_URI" not configured `);
    return "";
  }
  if (uri.indexOf("{{") >= 0) {
    throw new Error(
      `invalid uri or network not supported by nod eprovider : ${uri}`
    );
  }
  return uri;
}

export function deploymentForEnv(networkName: string): Record<string, string> {
  if (networkName === "goerli") {
    const {
      abi,
      address,
      // eslint-disable-next-line @typescript-eslint/no-var-requires
    } = require(`../deployments/${networkName}/CryptOrchidGoerli.json`);

    return {
      address,
      abi,
    };
  }
  const {
    abi,
    address,
    // eslint-disable-next-line @typescript-eslint/no-var-requires
  } = require(`../deployments/${networkName}/CryptOrchidERC721.json`);

  return {
    address,
    abi,
  };
}

export function getMnemonic(networkName?: string): string {
  if (networkName) {
    const mnemonic = process.env["MNEMONIC_" + networkName.toUpperCase()];
    if (mnemonic && mnemonic !== "") {
      return mnemonic;
    }
  }

  const mnemonic = process.env.MNEMONIC;
  if (!mnemonic || mnemonic === "") {
    return "test test test test test test test test test test test junk";
  }
  return mnemonic;
}

export function accounts(networkName?: string): { mnemonic: string } {
  return { mnemonic: getMnemonic(networkName) };
}

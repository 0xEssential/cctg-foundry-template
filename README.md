# Foundry template

This is a template for a Foundry project that uses 0xEssential's [Cross-Chain Token Gating](https://0xessential.gitbook.io/cross-chain-token-gating/).

Review the [Foundry](https://github.com/gakonst/foundry) project for development documentation.

## Contract

The sample contract inherits and initializes EssentialERC2771Context and includes an example for writing a function that depends on verified NFT ownership from another EVM chain.

## Test

The test directory includes a utility contract for constructing signatures accepted by EssentialForwarder, and a test contract that demonstrates how to test the token gated function from the example contract.

## Resources

- [Documentation](https://0xessential.gitbook.io/cross-chain-token-gating/)
- [0xEssential Discord](https://discord.gg/9dJVN7WFRE)
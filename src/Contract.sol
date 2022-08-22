// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "essential-contracts/contracts/fwd/EssentialERC2771Context.sol";

contract Contract is EssentialERC2771Context {
  address public lastCaller;
  mapping(address => uint256) public lastNFT;

  constructor(address trustedForwarder) EssentialERC2771Context(trustedForwarder) {}

  function tokenGatedFunction() external onlyForwarder {
    lastCaller = _msgSender();
    IForwardRequest.NFT memory nft = _msgNFT();
    lastNFT[nft.contractAddress] = nft.tokenId;
  }
}

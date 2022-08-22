// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {SigUtils} from "./utils/SigUtils.sol";
import {EssentialForwarder} from "essential-contracts/contracts/fwd/EssentialForwarder.sol";
import {IForwardRequest} from "essential-contracts/contracts/fwd/IForwardRequest.sol";
import {Contract} from "../src/Contract.sol";

contract ContractTest is Test {
    using ECDSA for bytes32;

    EssentialForwarder internal forwarder;
    SigUtils internal sigUtils;
    Contract internal implementationContract;

    uint256 internal ownershipSignerPrivateKey;
    address internal ownershipSigner;
    string[] internal urls;

    uint256 internal playerPrivateKey;
    address internal player;
    uint256 internal playerNonce;

    address internal nftContract;

    // helper for building request struct
    function buildRequest(bytes memory selector) internal returns (IForwardRequest.ERC721ForwardRequest memory req) {
        req = IForwardRequest.ERC721ForwardRequest({
            to: address(implementationContract),
            from: player,
            authorizer: player,
            nftContract: nftContract,
            nonce: playerNonce,
            nftChainId: block.chainid,
            nftTokenId: 1,
            targetChainId: block.chainid,
            value: 0,
            gas: 1e6,
            data: selector
        });

        playerNonce += 1;
    }

    // helper for signing request struct
    function signRequest(IForwardRequest.ERC721ForwardRequest memory request) internal returns (bytes memory) {
        bytes32 digest = sigUtils.getTypedDataHash(request);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(playerPrivateKey, digest);
        return abi.encodePacked(r, s, v);
    }

    // helper for mocking REST API for signing ownership
    function mockOwnershipSig(IForwardRequest.ERC721ForwardRequest memory request) internal returns (bytes memory) {
        bytes32 message = forwarder
            .createMessage(
                request.from,
                request.authorizer,
                request.nonce,
                request.nftChainId,
                request.nftContract,
                request.nftTokenId,
                block.timestamp
            )
            .toEthSignedMessageHash();

        (uint8 vMock, bytes32 rMock, bytes32 sMock) = vm.sign(ownershipSignerPrivateKey, message);
        return abi.encodePacked(rMock, sMock, vMock);
    }

    function metaTx(bytes memory encodedFunc) internal {
        IForwardRequest.ERC721ForwardRequest memory req = buildRequest(encodedFunc);

        bytes memory sig = signRequest(req);
        bytes memory data = abi.encode(block.timestamp, req, sig);
        bytes memory response = mockOwnershipSig(req);

        forwarder.executeWithProof(response, data);
    }
    
    function setUp() public {
        forwarder = new EssentialForwarder("EssentialForwarder", urls);
        sigUtils = new SigUtils(forwarder._domainSeparatorV4());
        implementationContract = new Contract(address(forwarder));

        ownershipSignerPrivateKey = 0xB12CE;
        ownershipSigner = vm.addr(ownershipSignerPrivateKey);

        forwarder.setOwnershipSigner(ownershipSigner);

        playerPrivateKey = 0xC11CE;
        player = vm.addr(playerPrivateKey);
    }

    function testTokenGatedFunction() public {
        metaTx(abi.encode(keccak256("tokenGatedFunction()")));

        assertEq(player, implementationContract.lastCaller());
        assertEq(1, implementationContract.lastNFT(nftContract));
    }
}

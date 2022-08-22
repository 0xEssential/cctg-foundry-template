// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./IForwardRequest.sol";

interface IEssentialPlaySession {
    function getSession(address authorizer) external view returns (IForwardRequest.PlaySession memory);

    function createSession(address authorized, uint256 length) external;

    function verifyAuthorization(address authorizer, address benficiary) external view returns (bool);
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

import "OpenZeppelin/openzeppelin-contracts@4.1.0/contracts/access/AccessControl.sol";

contract TokenRegistry is AccessControl {
    mapping(address => string) addressToSymbol;
    mapping(string => address) symbolToAddress;

    bytes32 public constant MAPPER_ROLE = keccak256("MAPPER_ROLE");

    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MAPPER_ROLE, msg.sender);
    }

    function setMapping(
        address[] memory tokenAddresses,
        string[] memory tokenSymbols
    ) external {
        require(hasRole(MAPPER_ROLE, msg.sender), "NOT_A_MAPPER");
        require(
            tokenAddresses.length == tokenSymbols.length,
            "address-and-symbols-length-not-match"
        );
        for (uint256 idx = 0; idx < tokenAddresses.length; idx++) {
            addressToSymbol[tokenAddresses[idx]] = tokenSymbols[idx];
            symbolToAddress[tokenSymbols[idx]] = tokenAddresses[idx];
        }
    }

    function getSymbol(address tokenAddress)
        external
        view
        returns (string memory)
    {
        return addressToSymbol[tokenAddress];
    }

    function getAddress(string memory tokenSymbol)
        external
        view
        returns (address)
    {
        return symbolToAddress[tokenSymbol];
    }
}

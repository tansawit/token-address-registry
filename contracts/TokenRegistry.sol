// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

import "OpenZeppelin/openzeppelin-contracts@4.1.0/contracts/access/AccessControl.sol";

/// @title Token Registry
/// @author Sawit Trisirisatayawong (@tansawit)
contract TokenRegistry is AccessControl {
    mapping(address => string) addressToSymbol;
    mapping(string => address) symbolToAddress;

    bytes32 public constant MAPPER_ROLE = keccak256("MAPPER_ROLE");

    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MAPPER_ROLE, msg.sender);
    }

    /// @notice Set a mapping between a token address and symbol
    /// @dev takes two lists of token addresses and symbols, and create a mapping between them
    /// the two list must be the same length
    /// only callable by an address with a MAPPER role
    /// @param tokenAddresses list of token addresses to map to symbols
    /// @param tokenSymbols list of token symbols to map to addresses
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

    /// @notice get the corresponding token symbol of a given token contract address
    /// @param tokenAddress address of the token to query to symbol of
    function getSymbol(address tokenAddress)
        external
        view
        returns (string memory)
    {
        return addressToSymbol[tokenAddress];
    }

    /// @notice get the corresponding token address of a given token symbol
    /// @param tokenSymbol symbol of the token to query to address of
    function getAddress(string memory tokenSymbol)
        external
        view
        returns (address)
    {
        return symbolToAddress[tokenSymbol];
    }
}

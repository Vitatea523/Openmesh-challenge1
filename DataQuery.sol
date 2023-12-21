// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IDataQuery {
    function getData(bool isOnChain, bytes[] memory _parameter) external returns (bytes[] memory);
}

contract DataQuery is IDataQuery {

    event QueryResult(bytes[] result);
    

    // Chainlink ETH/USD Address of the price aggregator
    AggregatorV3Interface internal priceFeed;
    bytes[] public data;

    // Constructor that initializes the Chainlink ETH/USD price aggregator address
    constructor() {
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    // A function to get data
   // A function to get data
    function getData(bool isOnChain, bytes[] memory _parameter) external returns (bytes[] memory) {
        if (isOnChain) {
            // If it is on-chain data, return the on-chain data directly
            data = getOnChainData(_parameter);
        } else {
            // If it is off-chain data, obtain the ETH/USD price via Chainlink
            data = getOffChainData(_parameter);
        }
        // Trigger event notification result
        emit QueryResult(data);
        // No need to return data explicitly as it's a state variable
    }

    // Sample function to get on-chain data
    function getOnChainData(bytes[] memory _parameter) internal view returns (bytes[] memory) {
        // Here you can add specific on-chain data query logic
        // For example, let's assume you want to return an array with two element
        return _parameter;
    }

    // Example function to get data off chain (use Chainlink to get ETH/USD price)
    function getOffChainData(bytes[] memory _parameter) internal view returns (bytes[] memory) {
        // In this function, interact with Chainlink or another off-chain data source
        // and return the obtained data
        return _parameter;
    }
}
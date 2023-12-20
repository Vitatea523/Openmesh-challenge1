// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IDataQuery {
    function getData(string calldata _parameter) external;
}

contract DataQuery is IDataQuery {

    event QueryResult(string result);
    

    // Chainlink ETH/USD Address of the price aggregator
    AggregatorV3Interface internal priceFeed;
    string public data;

    // Constructor that initializes the Chainlink ETH/USD price aggregator address
    constructor() {
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    // A function to get data
    function getData(string memory _parameter) external returns (string memory){
        if (isOnChain) {
            //TODO
            // If it is on-chain data, return the on-chain data directly
            data = getOnChainData();
        } else {
            //TODO
            // If it is off-chain data, the ETH/USD price is obtained via Chainlink
            data = getOffChainData();
        }
        // Trigger event notification result
        emit QueryResult(data);
        return data; 
    }

    // Sample function to get on-chain data
    function getOnChainData() internal view returns (string memory) {
        // Here you can add specific on-chain data query logic
        // Returns on-chain data
        return "On-chain data";
    }

    // Example function to get data off chain (use Chainlink to get ETH/USD price)
    function getOffChainData() internal view returns (string memory) {
        // Get the ETH/USD price via Chainlink
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Converts integer prices to strings
        return integerToString(uint256(price));
    }

    // Helper function: Converts integers to strings
    function integerToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 length;

        while (temp > 0) {
            temp /= 10;
            length++;
        }

        bytes memory result = new bytes(length);
        uint256 i = length - 1;
        temp = value;

        while (temp > 0) {
            result[i--] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }

        return string(result);
    }
}
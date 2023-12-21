// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IDataQuery {
    function getData(bool isOnChain, string memory dataName)
        external
        returns (bytes memory);
}

contract DataQuery is IDataQuery {
    event QueryResult(bytes result);

    mapping(string => address) public cryptoPrice;

    // Chainlink ETH/USD Address of the price aggregator
    AggregatorV3Interface internal priceFeed;
    bytes public data;

    // Constructor that initializes the Chainlink ETH/USD price aggregator address
    constructor() {
        cryptoPrice["BTC / ETH"] = 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22;
        cryptoPrice["BTC / USD"] = 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43;
        cryptoPrice["BTC / USD"] = 0x4b531A318B0e44B549F3b2f824721b3D0d51930A;
        cryptoPrice["CZK / USD"] = 0xC32f0A9D70A34B9E7377C10FDAd88512596f61EA;
        cryptoPrice["DAI / USD"] = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;
        cryptoPrice["ETH / USD"] = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        cryptoPrice["EUR / USD"] = 0x1a81afB8146aeFfCFc5E50e8479e826E7D55b910;
        
    }

    // A function to get data
    function getData(bool isOnChain, string memory dataName)
        external
        returns (bytes memory)
    {
        if (isOnChain) {
            // If it is on-chain data, return the on-chain data directly
            data = getOnChainData();
        } else {
            // If it is off-chain data, obtain the ETH/USD price via Chainlink
            data = getOffChainData(dataName);
        }
        // Trigger event notification result
        emit QueryResult(data);
        return data;
    }

    // Sample function to get on-chain data
    function getOnChainData()
        internal
        view
        returns (bytes memory)
    {
        // Here you can add specific on-chain data query logic
        return data;
    }

    

// returns (uint80, int256, uint256, uint256, uint80)
    function getOffChainData(string memory crypto)
        internal
        returns (bytes memory)
        
    {
        priceFeed = AggregatorV3Interface(
            cryptoPrice[crypto]
        );
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        bytes memory encodedData = abi.encode(roundId, answer, startedAt, updatedAt, answeredInRound);

        return encodedData;
    }

    function addMapping(string memory symbol, address tokenAddress) external {
        cryptoPrice[symbol] = tokenAddress;
    }

    function getAddress(string memory symbol) external view returns (address) {
        return cryptoPrice[symbol];
    }
   
}

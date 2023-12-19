// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface IDataQuery {
    function getData(string calldata _parameter) external;
}

contract DataQuery is IDataQuery {

    event QueryResult(string result);
    

    // Chainlink ETH/USD价格聚合器地址
    AggregatorV3Interface internal priceFeed;
    string public data;

    // 构造函数，初始化 Chainlink ETH/USD价格聚合器地址
    constructor() {
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    // 获取数据的函数
    function getData(string memory _parameter) external {
        if (isOnChain) {
            // 如果是链上数据，直接返回链上数据
            data = getOnChainData();
        } else {
            // 如果是链下数据，通过 Chainlink 获取 ETH/USD 价格
            data = getOffChainData();
        }
        // 触发事件通知结果
        emit QueryResult(data);
    }


    // 获取链上数据的示例函数
    function getOnChainData() internal view returns (string memory) {
        // 这里可以添加具体的链上数据查询逻辑
        // 返回链上数据
        return "On-chain data";
    }

    // 获取链下数据的示例函数（使用 Chainlink 获取 ETH/USD 价格）
    function getOffChainData() internal view returns (string memory) {
        // 通过 Chainlink 获取 ETH/USD 价格
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // 将整数价格转换为字符串
        return integerToString(uint256(price));
    }

    // 辅助函数：将整数转换为字符串
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
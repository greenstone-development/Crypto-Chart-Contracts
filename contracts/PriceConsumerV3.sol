// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        // Rinkeby ETH/USD price feed: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }

    function latestRoundData()
        public
        view
        returns (
            uint80, // roundId
            int256, // price (divide by 10^8 to get USD)
            uint256, // startedAt (unix timestamp)
            uint256, // updatedAt (unix timestamp)
            uint80 // answeredInRound
        )
    {
        return priceFeed.latestRoundData();
    }

    function getRoundData(uint80 _roundId)
        public
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        (
            uint80 roundId,
            int256 price,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.getRoundData(_roundId);
        require(updatedAt > 0, "Round not complete");
        return (roundId, price, startedAt, updatedAt, answeredInRound);
    }
}

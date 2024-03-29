// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketRegistry is Ownable {
    event SetMarketProxy(
        uint indexed index,
        Market market
    );
    struct Market {
        address proxy;
        bool isLib;
        bool isActive;
    }

    Market[] public markets;

    constructor(address[] memory proxies, bool[] memory isLibs, address _owner) {
        require(proxies.length == isLibs.length,"proxies and isLibs length mismatched");
        for (uint256 i = 0; i < proxies.length; i++) {
            require(proxies[i] != address(0), "proxy cannot be zero address");
            markets.push(Market(proxies[i], isLibs[i], true));
            emit SetMarketProxy(i, Market(proxies[i], isLibs[i], true));
        }
        _transferOwnership(_owner);
    }

    function marketsLength() view public returns (uint256){
        return markets.length;
    }

    function addMarket(address proxy, bool isLib) external onlyOwner {
        require(proxy != address(0), "proxy cannot be zero address");
        markets.push(Market(proxy, isLib, true));
        emit SetMarketProxy(markets.length - 1, Market(proxy, isLib, true));
    }

    function setMarketStatus(uint256 marketId, bool newStatus) external onlyOwner {
        Market storage market = markets[marketId];
        market.isActive = newStatus;
        emit SetMarketProxy(marketId, markets[marketId]);
    }

    function setMarketProxy(uint256 marketId, address newProxy, bool isLib) external onlyOwner {
        require(newProxy != address(0), "newProxy cannot be zero address");
        Market storage market = markets[marketId];
        market.proxy = newProxy;
        market.isLib = isLib;
        emit SetMarketProxy(marketId, markets[marketId]);
    }
}

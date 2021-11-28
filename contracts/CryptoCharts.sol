// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CryptoCharts is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter public totalMinted;
    Counters.Counter public totalSupply;

    string[] public ipfsLinks;

    event ChartMinted(address sender, uint256 tokenId);

    constructor() ERC721("CryptoCharts", "CC") {}

    function addChart(string memory ipfsLink) external onlyOwner {
        ipfsLinks.push(ipfsLink);
        totalSupply.increment();
    }

    function mintChart(uint256 tokenId) public {
        require(tokenId < totalSupply.current(), "Token ID is out of range");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, ipfsLinks[tokenId]);

        emit ChartMinted(msg.sender, tokenId);
        totalMinted.increment();
    }

    function getMintedCount() public view returns (uint256) {
        return totalMinted.current();
    }
}

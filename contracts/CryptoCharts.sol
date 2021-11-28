// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CryptoCharts is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private totalMinted;
    Counters.Counter public totalSupply;

    mapping(uint256 => string) public tokenIdToIPFS;

    event ChartMinted(address sender, uint256 mapIndex);

    constructor() ERC721("CryptoCharts", "CC") {}

    function addChart(uint256 tokenId, string memory ipfsLink) external onlyOwner {
        tokenIdToIPFS[tokenId] = ipfsLink;
        totalSupply.increment();
    }

    function mintChart(uint256 tokenId) public {
        require(tokenId < totalSupply.current(), "Token ID is out of range");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenIdToIPFS[tokenId]);

        emit ChartMinted(msg.sender, tokenId);
        totalMinted.increment();
    }

    function getMintedCount() public view returns (uint256) {
        return totalMinted.current();
    }
}

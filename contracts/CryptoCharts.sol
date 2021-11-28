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

   
    /**
    * addChart : Adds chart IPFS link to string array holding IPFS links]
    * @param  ipfsLink  IPFS link string of format ipfs://wewewrdfadfsdsdfdsdffsdf/metadata.json
    */

    function addChart(string memory ipfsLink) external onlyOwner {
        ipfsLinks.push(ipfsLink);
        totalSupply.increment();
    }

     /**
    * mintChart : function called to mintPriceCart token ,emits event chartMinted that could be used testing purposes
    * @param tokenId : token id is based on index of the 'ipfsLinks' string array
    */

    function mintChart(uint256 tokenId) public {
        require(tokenId < totalSupply.current(), "Token ID is out of range");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, ipfsLinks[tokenId]);

        emit ChartMinted(msg.sender, tokenId);
        totalMinted.increment();
    }
}

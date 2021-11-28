// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoCharts is ERC721URIStorage, Ownable {
    string[] public ipfsLinks;

    constructor() ERC721("CryptoChart", "CC") {}

    function addChart(string memory ipfsLink) external onlyOwner {
        ipfsLinks.push(ipfsLink);
    }

    function requestMint(address buyer, uint256 tokenId) public {
        require(tokenId < ipfsLinks.length, "Token ID is out of range");
        _safeMint(buyer, tokenId);
        _setTokenURI(tokenId, ipfsLinks[tokenId]);
    }
}

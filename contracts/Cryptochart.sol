// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Import open zeppline contraces for NFTS
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//,AccessControl
contract CryptoChart is ERC721URIStorage {
    string[] public ipfsCIDS;

    constructor() ERC721("CryptoChart", "CC") {}

    // TODO: Check permission of caller
    function addChart(string memory ipfsCID) public {
        ipfsCIDS.push(ipfsCID);
    }

    //Front end to call this function when buyer attempts to buy a chart
    function requestMint(address buyer, uint256 tokenId) public
    {
        require(tokenId < ipfsCIDS.length, "Token ID is out of range");
        // TODO: Make better variable names
        _safeMint(buyer, tokenId);
        _setTokenURI(tokenId, ipfsCIDS[tokenId]);
    }
}

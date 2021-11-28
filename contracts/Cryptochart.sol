// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Import open zeppline contraces for NFTS
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//using openzellpin counters
import "@openzeppelin/contracts/utils/Counters.sol";


import "@openzeppelin/contracts/access/AccessControl.sol";


//,AccessControl
contract CryptoChart is ERC721URIStorage,AccessControl{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

   //front end can call and pick up these charts to display them
    struct PriceChart {
        string chartURI;
        string name;
        bool minted;
    }
    PriceChart [] public priceCharts;



   constructor() ERC721("priceChart", "priceChart")
   {
       _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
   }

   //function to add charts , Node server to call this function to add charts
   function addChat(string memory imageUrl ,string memory name) public {
       
       bool minted = false;
       PriceChart memory priceChart = PriceChart(
            imageUrl,
            name,
            minted
       );
       priceCharts.push(priceChart);

   }
   //front end to call this function to diplay all available charts
   function viewAllCharts() public returns (PriceChart [] memory) {
       return priceCharts;
   }

   //Front end to call this function when buyer attempts to buy a chart
   function requestMint(address buyer , string memory tokenURI) public returns(uint256){
       //just checking if url passed exists in our charts
       for (uint i = 0; i < priceCharts.length; i++) {
           if((compareStrings(tokenURI, priceCharts[i].chartURI)) && (priceCharts[i].minted==false)){
            grantRole(MINTER_ROLE, buyer);
            uint256 mintedTokenId = mintPriceChart(buyer,tokenURI ,priceCharts[i] );
            return mintedTokenId;
           }  
       }
     return 0; 
   }

   // Mint chart token and send it to buyer address
   function mintPriceChart(address buyer, string memory tokenURI , PriceChart memory priceChart)
        public onlyRole(MINTER_ROLE)
        returns (uint256)
   {    
       uint256 newChartTokenId=0;
       require(hasRole(MINTER_ROLE, buyer),"Signature invalid or unauthorized");
        
        _tokenIds.increment();
        newChartTokenId = _tokenIds.current();
        _safeMint(buyer, newChartTokenId);
        _setTokenURI(newChartTokenId, tokenURI);
        priceChart.minted=true;
      
        //revoke the role after they mint the token so they can not mint it again
        revokeRole(MINTER_ROLE,  buyer);
        return newChartTokenId;
   } 

   function supportsInterface(bytes4 interfaceId) public view virtual override (AccessControl, ERC721) returns (bool) {
    return ERC721.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
   }

   function compareStrings(string memory a, string memory b) public view returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
}

}
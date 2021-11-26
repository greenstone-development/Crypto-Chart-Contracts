// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Import open zeppline contraces for NFTS
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//using openzellpin counters
import "@openzeppelin/contracts/utils/Counters.sol";

// import VRF(Verifiable Random Function)  VRFConsumerBase from chainlink for? 
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";

//,AccessControl
contract PriceChart is ERC721URIStorage{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint public immutable interval=6788788;
    uint public lastTimeStamp;
    //bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

   constructor(address owner,string memory tokenURI) ERC721("priceChart", "priceChart") {
       
       lastTimeStamp = block.timestamp;

       // _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // we need the token or something to tell if someone is owner
       // if(owner==msg.sender){
            //grantRole(MINTER_ROLE, owner);
        //}
   }
   //public onlyRole(MINTER_ROLE)
   function mintPriceChart(address owner, string memory tokenURI)
        public
        returns (uint256)
   {    
       uint256 newChartTokenId=0;
        
        //if(hasRole(MINTER_ROLE, owner)){
            _tokenIds.increment();
            newChartTokenId = _tokenIds.current();
            _safeMint(owner, newChartTokenId);
            _setTokenURI(newChartTokenId, tokenURI);
        //}
        //revoke the role after they mint the token so they can not mint it again
        //revokeRole(MINTER_ROLE,  owner);
        return newChartTokenId;
   } 

}
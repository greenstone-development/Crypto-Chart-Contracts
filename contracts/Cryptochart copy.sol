// SPDX-License-Identifier: MIT

// Import open zeppline contraces for NFTS
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// import VRF(Verifiable Random Function)  VRFConsumerBase from chainlink for? 
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

//allows us to interact with chain link data feeds
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract PriceChart is ERC721URIStorage , VRFConsumerBase {

    AggregatorV3Interface internal priceFeed;
    bytes32 internal keyHash;
    uint256 internal fee;
    address public VRFCoordinator;
    address public LinkToken;


    struct PriceChart{
        string name;
        bool minted;
        uint requestedTimeStamp;
        uint256 startTimestamp;
        uint256 endTimestamp;
        uint256 movingAverage;
        uint256 high;
        uint256 low;  
    }

    PriceChart [] public priceCharts;
    event requestedCharacter(bytes32 indexed requestId);
    mapping (bytes32 => address) public requestIdToSender ;
    mapping (bytes32 => string) public requestIdToTokenURI;

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash) public  
     VRFConsumerBase(_VRFCoordinator,_LinkToken)
     ERC721("priceChart", "priceChart")
    {
         VRFCoordinator = _VRFCoordinator;
         LinkToken = _LinkToken;
         keyHash = _keyHash;
         fee = 0.1 *10**18;  //0.d Link
    } 
  
    // function to create NFT  
    // token url for the address of our chart asset (need this from FileCoin)
    // user provided seed for scarcity
    function generateNewChart(address userProvidedSeed, string memory tokenURI)
    public returns(bytes32){
        //fund chainLink VRF with Link tokens
        require (
            LINK.balanceOf(address(this)) >= fee,
            "Not enough Link -fill contract with fauces"
        );
        //sending request to VRF
        //keyHash to help verify that the number is actually random
        bytes32 requestId = requestRandomness(keyHash, fee,userProvidedSeed);
        //mapping request The random number we got is the same random number associated with the request
        //make sure that when chain link returns it should assign the random number to the correct call.
        requestIdToSender [requestId] = msg.sender;
        //map request id to Token URI
        requestToTokenURI [requestId] = tokenURI;
        //emit event to easily access requestId when testing or for any other reason
        emit requestedCollectible(requestId);
        return requestId;

    }
    //vrf coordinator actually calls fulfillrandom ness under the hood and calls this function 
    //with the request id and the random number it generated
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        address  chartOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI [requestId];

        uint256 newId = priceCharts.length;

        // inherited from openZpplin
        _safeMint(chartOwner, newId);
        _setTokenURI(newId,tokenURI);
        
        //keccak256 is a hashfunction
        uint256 rearity = uint256(keccak256(abi.encode(randomNumber,1))) % 100;
        bool minted = true;
        
        uint256 experience=0;
        PriceChart memory priceChart = PriceChart(
            rearity,
            minted
            requestToCharacterName[requestId]
        );
        characters.push(character);
        _safeMint(requestIdToSender[requestId],newId);
       
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

    // We need keepers to occasionally get our price chatss and create NFTs.
    function checkUpkeep(bytes calldata checkData)external returns (bool upkeepNeeded,bytes memory performData){

    }

    function checkUpkeep(bytes calldata checkData) public view returns(bool, bytes memory) {
        address wallet = abi.decode(checkData, (address));
        return (wallet.balance < 1 ether, bytes(""));
    }


    

}
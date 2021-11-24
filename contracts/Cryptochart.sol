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

        uint256 startTimestamp;
        uint256 endTimestamp;
        string name;
        uint256 movingAverage;
        uint256 high;
        uint256 low;  
    }

    PriceChart [] public priceCharts;
    event requestedCharacter(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash, address _priceFeed) public  
     VRFConsumerBase(_VRFCoordinator,_LinkToken)
     ERC721("priceChart", "priceChart")
    {
         VRFCoordinator = _VRFCoordinator;
         priceFeed = AggregatorV3Interface(_priceFeed);
         LinkToken = _LinkToken;
         keyHash = _keyHash;
         fee = 0.1 *10**18;  //0.d Link
    } 

    function generateNewChart(string memory name)
    public returns(bytes32){
        //fund chainLink VRF with Link tokens
        require (
            LINK.balanceOf(address(this)) >= fee,
            "Not enough Link -fill contract with fauces"
        );
        //sending request to VRF
        bytes32 requestId = requestRandomness(keyHash, fee);
        //mapping request id to name
        requestToCharacterName [requestId] = name;
        requestToSender [requestId] = msg.sender;
        //emit event to easily access requestId when testing or for any other reason
        emit requestedCharacter(requestId);
        return requestId;

    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 newId = priceCharts.length;
        uint256 experience = 0;

        characters.push(
            Character(
                strength,
                dexterity,
                constitution,
                intelligence,
                wisdom,
                charisma,
                experience,
                requestToCharacterName[requestId]
            )
        );
        _safeMint(requestToSender[requestId], newId);
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

    

}
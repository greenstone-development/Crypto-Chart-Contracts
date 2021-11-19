pragma solidity ^0.8.7;

// Import open zeppline contraces for NFTS
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// import VRF(Verifiable Random Function)  VRFConsumerBase from chainlink for? 
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

//allows us to interact with chain link data feeds
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract DnDCharacter is ERC721URIStorage , VRFConsumerBase {
    AggregatorV3Interface internal priceFeed;
    bytes32 internal keyHash;
    uint256 internal fee;
    address public VRFCoordinator;
    address public LinkToken;

    struct Character{
        int256 strength;
        uint256 dexterity;
        uint256 constitution;
        uint256 intelligence;
        uint256 wisdom;
        uint256 charisma;
        uint256 experience;
        string name;
        string names;
    }

    Character [] public characters;
    mapping(bytes32 => string) public requestToCharacterName;
    mapping(bytes32 => address) public  requestToSender;

    event requestedCharacter(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash, address _priceFeed) public  
     VRFConsumerBase(_VRFCoordinator,_LinkToken)
     ERC721("DungeonsAndDragonsCharacter", "D&D")
    {
         VRFCoordinator = _VRFCoordinator;
         priceFeed = AggregatorV3Interface(_priceFeed);
         LinkToken = _LinkToken;
         keyHash = _keyHash;
         fee = 0.1 *10**18;  //0.d Link
    }
    //function to make a request for randomness fo the VRF 
    function requestNewRandomCharacter(string memory name)
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
    function fulfillRandomness(bytes32 requestId , uint256 randomNumber)
    internal override
    {
        uint256 newId =characters.length;
        int256 strength = (getLatestPrice()/1000000000);
        uint dexterity = randomNumber % 100;
        //keccak256 is a hashfunction
        uint256 constitution = uint256(keccak256(abi.encode(randomNumber,1))) % 100;
        uint256 intelligence = uint256(keccak256(abi.encode(randomNumber,2))) % 100;
        uint256 wisdom =uint256(keccak256(abi.encode(randomNumber,3))) % 100;
        uint256 charisma =uint256(keccak256(abi.encode(randomNumber,4))) % 100;
        uint256 experience=0;
        Character memory character = Character(
            strength,
            dexterity,
            constitution,
            intelligence,
            wisdom,
            charisma,
            experience,
            requestToCharacterName[requestId]
        );
        characters.push(character);
        _safeMint(requestToSender[requestId],newId);
    }
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


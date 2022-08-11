pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage{
    constructor(address _marketaddress)
    ERC721("HEDERA","H-DERA"){
        Marketaddress = _marketaddress;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    address private Marketaddress;

    
    mapping(address => uint[])NFTOwned;
    mapping(uint => address)NFTOwnerId;
    mapping(uint => mapping(address =>bool))NFTOwner; 
    

    event NFTMinted(address indexed _by,uint _time);


    function MintNFT(string memory _tokenURI)public returns(uint){
        _tokenId.increment();
        uint id = _tokenId.current();
        _safeMint(msg.sender,id);
        _setTokenURI(id, _tokenURI);
       NFTOwner[id][msg.sender] = true;
       NFTOwned[msg.sender].push(id);
       NFTOwnerId[id] = msg.sender;
       _approve(Marketaddress,id);
       emit NFTMinted(msg.sender,block.timestamp);
       return id;
       
       
    }

    function RevealTokensID()public view returns(uint[]memory){
        return NFTOwned[msg.sender];
    }
    function RevealUserByID(uint _id)public view returns(address){
        return NFTOwnerId[_id];
    }

    function RevealTokenUserID(address _user)public view returns(uint[]memory){
        return NFTOwned[_user];
    }
    function IsNFTOwner(address _user,uint _tokenid)public view returns(bool success){
        return NFTOwner[_tokenid][_user];
    }

}
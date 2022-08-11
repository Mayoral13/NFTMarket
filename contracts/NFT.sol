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

    
    mapping(address => uint[])NFTMinted;
    mapping(uint => address)NFTOwnerId;
    mapping(uint => mapping(address =>bool))NFTMinter; 
    

    event NFTMint(address indexed _by,uint _time);


    function MintNFT(string memory _tokenURI)public returns(uint){
        _tokenId.increment();
        uint id = _tokenId.current();
        _safeMint(msg.sender,id);
        _setTokenURI(id, _tokenURI);
       NFTMinter[id][msg.sender] = true;
       NFTMinted[msg.sender].push(id);
       NFTOwnerId[id] = msg.sender;
       _approve(Marketaddress,id);
       emit NFTMint(msg.sender,block.timestamp);
       return id;
    }

    function RevealTokensID()public view returns(uint[]memory){
        return NFTMinted[msg.sender];
    }
    function RevealMinterByID(uint _id)public view returns(address){
        return NFTOwnerId[_id];
    }

    function RevealTokenMinterID(address _user)public view returns(uint[]memory){
        return NFTMinted[_user];
    }
    function IsNFTMinter(address _user,uint _tokenid)public view returns(bool success){
        return NFTMinter[_tokenid][_user];
    }

}
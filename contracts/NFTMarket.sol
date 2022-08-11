pragma solidity ^0.8.11;
import "./NFT.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _marketId;
    
       struct Listing{
        address NFTAddr;
        uint price;
        uint marketId;
        uint tokenId;
        uint duration;
        address payable seller;
        address payable buyer;
        bool sold;
        bool canceled;
       }

       mapping(uint => Listing)listing;
       mapping(address => uint)auction;

    function ListNFT(address _nftaddr,uint _price,uint _tokenid,uint _duration) nonReentrant public{
        require(NFT(_nftaddr).IsNFTOwner(msg.sender,_tokenid) == true,"You do not own the NFT");
        _marketId.increment();
        uint id = _marketId.current();
        listing[id].price = _price;
        listing[id].marketId = id;
        listing[id].tokenId = _tokenid;
        listing[id].duration = _duration;
        listing[id].seller = payable(msg.sender);
        IERC721(_nftaddr).transferFrom(msg.sender,address(this),_tokenid);
    }
    function BuyNFT()public{

    }

    function SearchNFT(uint _marketID)public view returns(address _nft,uint _price,uint _tokenId,uint _duration,address _seller,address _buyer,bool _sold,bool _canceled){
    require(listing[_marketID].seller != address(0),"Item does not exist");
    _nft = listing[_marketID].NFTAddr;
    _price = listing[_marketID].price;
    _tokenId = listing[_marketID].tokenId;
    _duration = listing[_marketID].duration;
    _seller = listing[_marketID].seller;
    _buyer = listing[_marketID].buyer;
    _sold = listing[_marketID].sold;
    _canceled = listing[_marketID].canceled;

    }
    
}



pragma solidity ^0.8.11;
import "./NFT.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NFTMarket is ReentrancyGuard,Ownable{
    using Counters for Counters.Counter;
    using SafeMath for uint;
    Counters.Counter private _marketId;
    uint listingFee = 0.05 ether;
    uint[] private MarketID;
    
       struct Listing{
        address NFTAddr;
        uint price;
        uint marketId;
        uint tokenId;
        uint duration;
        address minter;
        address payable seller;
        address payable buyer;
        bool sold;
        bool canceled;
        uint bought;
       }
       event NFTListed(address NFTAddr,uint price,uint marketId,uint tokenId,uint duration,address indexed seller);
       event NFTPurchased(uint price,uint marketId,uint tokenId,address indexed seller,address indexed buyer);
       event NFTListingCanceled(uint marketId,uint tokenId,address indexed by);

       mapping(uint => Listing)private listing;
       mapping(address => uint[])IDListed;
       mapping(uint => address)private IDListing;

    function ListNFT(address _nftaddr,uint _price,uint _tokenid,uint _duration) nonReentrant public payable{
        require(msg.value == listingFee,"Pay 0.05 ether to list item");
        require(_price > 1,"Set price to at least 1 wei");
        require(NFT(_nftaddr).IsNFTOwner(msg.sender,_tokenid) == true,"You do not own the NFT");
        _marketId.increment();
        uint id = _marketId.current();
        address seller = NFT(_nftaddr).RevealUserByID(_tokenid);
        listing[id].price = _price;
        listing[id].NFTAddr = _nftaddr;
        listing[id].marketId = id;
        listing[id].tokenId = _tokenid;
        listing[id].minter = seller;
        listing[id].duration = _duration.add(block.timestamp);
        listing[id].seller = payable(msg.sender);
        IDListing[id] = msg.sender;
        IDListed[msg.sender].push(id);
        NFT(_nftaddr).transferFrom(msg.sender,address(this),_tokenid);
        MarketID.push(id);
        emit NFTListed(_nftaddr,_price,id,_tokenid,_duration.add(block.timestamp),msg.sender);
    }
    

    function BuyNFT(uint _marketID)public payable nonReentrant{
        require(listing[_marketID].duration > block.timestamp,"Listing time exceeded");
        require(msg.value == listing[_marketID].price,"Pay Item price");
        require(listing[_marketID].seller != address(0),"Item does not exist");
        require(listing[_marketID].sold == false,"Item has been bought");
        require(listing[_marketID].canceled == false,"Item has been retrieved by seller");
        uint sent = msg.value;
        uint fee = (msg.value.mul(5)).div(100);
        uint recieve = sent.sub(fee);
        uint tokenId = listing[_marketID].tokenId;
        address _nftaddr = listing[_marketID].NFTAddr;
        address payable _seller = listing[_marketID].seller;
        listing[_marketID].sold = true;
        listing[_marketID].bought = block.timestamp;
        NFT(_nftaddr).transferFrom(address(this),msg.sender,tokenId);
        _seller.transfer(recieve);
        emit NFTPurchased(listing[_marketID].price,_marketID,tokenId,_seller,msg.sender);
    }

    function SearchNFT(uint _marketID)public view returns(address _nftaddr,uint _price,uint _tokenId,uint _duration,address _seller,address _buyer,bool _sold,bool _canceled,uint _bought){
    require(listing[_marketID].seller != address(0),"Item does not exist");
    _nftaddr = listing[_marketID].NFTAddr;
    _price = listing[_marketID].price;
    _tokenId = listing[_marketID].tokenId;
    _duration = listing[_marketID].duration;
    _seller = listing[_marketID].seller;
    _buyer = listing[_marketID].buyer;
    _sold = listing[_marketID].sold;
    _canceled = listing[_marketID].canceled;
    _bought = listing[_marketID].bought;
    }

    function CancelListing(uint _marketID)public nonReentrant{
        require(listing[_marketID].seller != address(0),"Item does not exist");
        require(IDListing[_marketID] == msg.sender,"You are not the Lister");
        uint tokenId = listing[_marketID].tokenId;
        address _nftaddr = listing[_marketID].NFTAddr;
        listing[_marketID].canceled = true;
        IDListed[msg.sender].pop();
        NFT(_nftaddr).transferFrom(address(this),msg.sender,tokenId);
        emit NFTListingCanceled(_marketID,tokenId,msg.sender);
    }
    function RevealAvailableID()public view returns(uint[]memory){
        return MarketID;
    }
    function RevealMyListedID()public view returns(uint[]memory){
        return IDListed[msg.sender];
    }  
    
}



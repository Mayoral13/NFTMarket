const market = artifacts.require("NFTMarket");
const nft = artifacts.require("NFT");
let catchRevert = require("../execption").catchRevert;
contract("NFTMarket",(accounts)=>{
    let admin = accounts[0];
    let user = accounts[1];
    let user1 = accounts[2];
    
    it("Should be able to deploy successfully",async()=>{
        const alpha = await nft.deployed();
        const beta = alpha.address;
        console.log("The deployed NFT address is :",beta.toString());
        assert(beta != "");
    });
    it("Can Mint NFT",async()=>{
        const alpha = await nft.deployed();
        const beta = await alpha.MintNFT("https://ipfs.io/ipfs/QmY72isiwW4aw2sx6dAFsZuGGAKbYcgoNNY2p2RjWwzXQN");
        const beta2 = await alpha.MintNFT("https://ipfs.io/ipfs/QmY72isiwW4aw2sx6dAFsZuGGAKbYcgoNNY2p2RjWwzXQN");
        const beta3 = await alpha.MintNFT("https://ipfs.io/ipfs/QmY72isiwW4aw2sx6dAFsZuGGAKbYcgoNNY2p2RjWwzXQN");
        const gamma = await alpha.IsNFTMinter(admin,1);
        assert.equal(gamma,true);
    });
    it("Can Reveal Token ID of Minter",async()=>{
        const alpha = await nft.deployed();
        const beta = await alpha.RevealTokensID();
        assert(beta != "");
    });
    it("Can Reveal address of Minter",async()=>{
        const alpha = await nft.deployed();
        const beta = await alpha.RevealMinterByID(1);
        assert.equal(beta,admin);
    });
   
    it("Deploys successfully",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.address;
        console.log("The NFT Market address is : ",beta.toString());
        assert(beta != "");
    });
    it("User cannot set price as 0 during listing",async()=>{
        const alpha = await market.deployed();
        const gamma = await nft.deployed();
        const nftaddr = gamma.address
        await catchRevert(alpha.ListNFT(nftaddr,0,1,3600,{value:100}));
    })

    it("Can List an Item",async()=>{
        const alpha = await market.deployed();
        const gamma = await nft.deployed();
        const nftaddr = gamma.address
        const beta = await alpha.ListNFT(nftaddr,1500,1,3600,{value:100});
        const beta2 = await alpha.ListNFT(nftaddr,1500,2,3600,{value:100});
        const goku = await alpha.RevealMyListedID();
        assert(goku != "");
    });
    it("Should revert if non owner tries to list NFT",async()=>{
        const alpha = await market.deployed();
        const gamma = await nft.deployed();
        const nftaddr = gamma.address
        await catchRevert(alpha.ListNFT(nftaddr,1500,1,3600,{from:user,value:100}));
    });
    it("Can search NFT that has been listed",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.SearchNFT(1);
        assert(beta != "");
    });
    it("Cannot search NFT that has not been listed",async()=>{
        const alpha = await market.deployed();
        await catchRevert(alpha.SearchNFT(10));
    });
    it("Can reveal ID on NFT Listed",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.RevealAvailableID();
        assert(beta != "");
    });
    it("Can reveal ID of NFT user has listed",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.RevealMyListedID();
        assert(beta != "");
    });
    it("Non Owner cannot cancel listing",async()=>{
        const alpha = await market.deployed();
        await catchRevert(alpha.CancelListing(1,{from:user1}));
    })
    it("Can Cancel listing",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.CancelListing(1);
        await catchRevert(alpha.BuyNFT(1,{value:1500,from:user}));
    });
    it("Lister Cannot buy listed NFT",async()=>{
        const alpha = await market.deployed();
        await catchRevert(alpha.BuyNFT(2,{value:1500,from:admin}));
    });
    it("Users must pay listing fee or else transaction will revert",async()=>{
        const alpha = await market.deployed();
        const gamma = await nft.deployed();
        const nftaddr = gamma.address
        await catchRevert(alpha.ListNFT(nftaddr,1500,3,3600));
    });
    it("Users cannot buy Items that have been bought",async()=>{
        const alpha = await market.deployed();
        const beta = await alpha.BuyNFT(2,{value:1500,from:user});
        await catchRevert(alpha.BuyNFT(2,{value:1500,from:user1}));
    });
    it("User cannot relist an item after listing it",async()=>{
        const gamma = await nft.deployed();
        const nftaddr = gamma.address;
        const alpha = await market.deployed();
        const beta = await alpha.ListNFT(nftaddr,1500,3,3600,{value:100});
        await catchRevert(alpha.ListNFT(nftaddr,1500,3,3600,{value:100}));
    });
    it("User cannot cancel listing that has been bought",async()=>{
        const alpha = await market.deployed();
        await catchRevert(alpha.CancelListing(2));
    });
    it("Users cannot buy item that has already been canceled",async()=>{
        const alpha = await market.deployed();
        await catchRevert(alpha.BuyNFT(1,{value:1500,from:user1}));
    });
});





  
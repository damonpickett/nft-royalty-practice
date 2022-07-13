// SPDX-License-Identifier: MIT

// This contract seeks to enable an NFT Agency to:
// 1. Mint multiple tokens for various tokenID's
// 2. Assign metadata to various token ID's
// 3. Enable whitelisted addresses to mint a set amount of NFTs by a particular date
// 4. Pays a royalty fee to an artist whenever an NFT is sold
// 5. Deployer enables minting
// 6. Deployer sets base token uri's
// 7. There is a return token uri function

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRoyaltyPractice is ERC1155, Ownable {
    // constants

    uint256 public immutable mintPrice;
    uint256 public totalSupply;
    uint256 public immutable maxSupply
    bool public mintEnabled;

    // uris for nft metadata
    mapping(uint256 => string) private _uris;

    // whitelisted addresses and how many tokens they can purchase
    mapping(address => uint) public whitelistedAddresses;

    // tokenID mapped to date whitelist option is valid
    mapping(uint256 => uint) public validUntil;

    // constructor
    constructor() payable ERC1155("NFTRoyaltyPractice") {
        // initialize variables
        mintPrice = 0.01 ether;
        totalSupply = 0;
        maxSupply = 
    }

    // functions

    // enables minting
    function setMintEnabled(bool mintEnabled_) external onlyOwner {
        mintEnabled = mintEnabled_;
    }

    // returns uri of a given tokenId
    function uri(uint256 tokenId) override public view returns (string memory) {
        return(_uris[tokenId]);
    }

    // sets the uri for each tokenID and stores in _uris mapping
    function setTokenUri(uint256 _tokenId, string memory _uri) public onlyOwner {
        _uris[_tokenId] = _uri;
    }

    // sets date for whitelisted addresses to mint by
    function setValidUntil(uint256 _tokenId, uint daysNo) public onlyOwner {
        validUntil[_tokenId] = block.timestamp + (daysNo * 1 days);
    }

    // returns bool whether whitelisted address can still mint
    function isValid(uint256 _tokenId) public view returns (bool) {
        return block.timestamp < validUntil[_tokenId];
    }

    // public mint
    function mint(address recipient, uint256 tokenId, uint256 amount) public payable {
        require(mintEnabled, "Minting has not been enabled.");
        require(msg.value == amount * mintPrice, "Incorrect mint value.");
        // HOW DO I LIMIT THE AMOUNT PER TOKENID???
        require(totalSupply + amount <= maxSupply, "Sorry, we're sold out.")

    }


}




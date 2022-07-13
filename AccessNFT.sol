// Plan for today:

// Prepare simple NFT contract for access
// add whitelist support
// add 'validUntil' timestamp
// allow to check which nft is valid
// prepare and upload metadata
// release to opensea
// q&a

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessNFT is ERC1155, Ownable {
    // uris for nft metadata
    mapping (uint256 => string) private _uris;
    // whitelisted addresses and how many tokens they can purchase
    mapping (address => uint) public whitelistedAddresses;
    // tokenId mapped to date whitelist option is valid
    mapping (uint256 => uint) public validUntil;

    constructor() ERC1155("") {}

    function uri(uint256 tokenId) override public view returns (string memory) {
        return(_uris[tokenId]);
    }

    function setTokenUri(uint256 _tokenId, string memory _uri) public onlyOwner {
        _uris[_tokenId] = _uri;
    }

    function setValidUntil(uint256 _tokenId, uint daysNo) public onlyOwner {
        validUntil[_tokenId] = block.timestamp + (daysNo * 1 days);
    }

    function isValid(uint256 _tokenId) public view returns (bool) {
        return block.timestamp < validUntil[_tokenId];
    }

    function mint(address recipient, uint256 tokenId, uint256 amount) public onlyOwner {
        _mint(recipient, tokenId, amount, "");
    }

    // allows owner to choose an address and how many nfts that address can mint
    function updateWhitelist(address _addr, uint _amount) public onlyOwner {
        whitelistedAddresses[_addr] = _amount;
    }

    // public function for whitelisted addresses to mint their nfts
    function whitelistMint(address recipient, uint256 tokenId, uint256 amount) public {
        require(amount >= 1, "please enter a valid number");
        require(whitelistedAddresses[msg.sender] >= amount, "not whitelisted");
        require(isValid == true);

        _mint(recipient, tokenId, amount, "");
        whitelistedAddresses[msg.sender] -= amount; 
    }

}
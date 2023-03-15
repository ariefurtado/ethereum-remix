// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Craftable {
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public {}
}

contract Trapp1ECraftedKicks is ERC721, Ownable, Pausable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint maxSupply = 250;

    constructor() ERC721("Trapp1EArtistKicksCrafted", "TAKC") {
        pause();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://trapp1e.com/nft/crafted/";
    }

    function craft(Craftable craftable, uint id) 
        public
        whenNotPaused
    {
        // Burn token from Craftable contract
        craftable.burn(msg.sender, id, 1);

        // Mint "Crafted" token for recipient
        safeMint(msg.sender);
    }

    function safeMint(address to) internal {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "T1E: Max supply of tokens reached.");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // The following functions are overrides required by Solidity.
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}

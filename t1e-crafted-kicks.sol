// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "https://github.com/Vectorized/closedsea/blob/main/src/OperatorFilterer.sol";

contract Craftable {
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public {}
}

contract Trapp1ECraftedKicks is ERC721, Ownable, Pausable, OperatorFilterer, ERC2981 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    bool public operatorFilteringEnabled;
    string public baseURI = "https://trapp1e.com/nft/crafted/";

    Craftable craftable;

    event Craft(address indexed sender, uint256 burnedTokenId, uint256 mintedTokenId);

    constructor(address _craftable) ERC721("Trapp1EArtistKicksCrafted", "TAKC") {
        // filter for opensea
        _registerForOperatorFiltering();
        operatorFilteringEnabled = true;

        // Set royalty receiver to the contract creator,
        // at 5% (default denominator is 10000).
        // _setDefaultRoyalty(msg.sender, 500);

        craftable = Craftable(_craftable);
        pause();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    function craft(uint256 tokenId)
        public
        whenNotPaused
    {
        craftable.burn(msg.sender, tokenId, 1);
        uint256 mintedId = safeMint(msg.sender);
        emit Craft(msg.sender, tokenId, mintedId);
    }

    function safeMint(address to) internal returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        return tokenId;
    }

    // Defaults

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
    //     _setDefaultRoyalty(receiver, feeNumerator);
    // }

    function setOperatorFilteringEnabled(bool value) public onlyOwner {
        operatorFilteringEnabled = value;
    }

    // The following functions are overrides required by Solidity.
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setApprovalForAll(address operator, bool approved)
        public
        override
        onlyAllowedOperatorApproval(operator)
    {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId)
        public
        override
        onlyAllowedOperatorApproval(operator)
    {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        override
        onlyAllowedOperator(from)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId)
        public
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function _operatorFilteringEnabled() internal view override returns (bool) {
        return operatorFilteringEnabled;
    }

    function _isPriorityOperator(address operator) internal pure override returns (bool) {
        // OpenSea Seaport Conduit:
        // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
        return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
    }
}

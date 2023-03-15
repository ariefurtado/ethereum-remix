// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.1/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.8.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.8.1/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts@4.8.1/token/ERC1155/extensions/ERC1155Supply.sol";

contract Trapp1EArtistKicks is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    constructor() ERC1155("https://trapp1e.com/artist/fesc/1") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract Trapp1EArtistKicks is ERC1155, Ownable, ERC1155Supply {
    uint256 mintCharge = 0.01 ether;
    uint256 maxSupply = 250;

    constructor() ERC1155("https://trapp1e.com/nft/artist/{id}.json") {}

    function mint(uint256 id, uint256 amount) public payable {
        require(msg.value == mintCharge * amount, "T1E: Not enough Ether provided.");
        require(totalSupply(id) + amount <= maxSupply, "T1E: Max supply of tokens reached.");
        _mint(msg.sender, id, amount, "");
    }

    function burn(address from, uint id, uint amount) public {
        _burn(from, id, amount);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

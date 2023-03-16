// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Trapp1EArtistKicks is ERC1155, Pausable, AccessControl, ERC1155Supply {
    string public constant name = "Trapp1EArtistKicks";
    string public constant symbol = "T1EAK";

    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
    uint256 public mintCharge = 0.01 ether;

    uint256 maxSupply = 250;

    constructor() ERC1155("https://trapp1e.com/nft/artist/{id}.json") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(uint256 id, uint256 amount) 
        public 
        payable 
        whenNotPaused 
    {
        require(msg.value == mintCharge * amount, "T1E: Not enough Ether provided.");
        require(totalSupply(id) + amount <= maxSupply, "T1E: Max supply of tokens reached.");
        _mint(msg.sender, id, amount, "");
    }

    function burn(address from, uint256 id, uint256 amount) public onlyRole(BURN_ROLE) {
        _burn(from, id, amount);
    }

    function updateMintCharge(uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        mintCharge = amount;
    }

    // Defaults
    
    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function setURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setURI(newuri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

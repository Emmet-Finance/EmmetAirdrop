// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract EmmetAirdrop is ERC1155, AccessControl, ERC1155Supply, ERC2981 {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @param royaltyReceiver a valid EOA or contract address
    /// @param feeNumerator an integer between 0 and 10000, where 10,000 = 100%, 1000 = 10%
    constructor(address royaltyReceiver, uint96 feeNumerator) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(URI_SETTER_ROLE, msg.sender);
        _setDefaultRoyalty(royaltyReceiver, feeNumerator);
    }

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function resetDefaultRoyalty(address royaltyReceiver, uint96 feeNumerator)
        public
        onlyRole(MINTER_ROLE)
    {
        _setDefaultRoyalty(royaltyReceiver, feeNumerator);
    }

    function removeRoyalties() public onlyRole(MINTER_ROLE) {
        // Reserved if the contract switches to royalties by tokenId
        _deleteDefaultRoyalty();
    }

    function setRoyaltiesByTokenId(uint256 tokenId, address royaltyReceiver, uint96 feeNumerator) public onlyRole(MINTER_ROLE) {
        _setTokenRoyalty(tokenId, royaltyReceiver, feeNumerator);
    }

    function removeRoyaltiesByTokenId(uint256 tokenId) public onlyRole(MINTER_ROLE) {
        // Reserved if the contract switches to default royalties
        _resetTokenRoyalty(tokenId);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyRole(MINTER_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        super._update(from, to, ids, values);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

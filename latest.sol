// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.0/security/Pausable.sol";
import "@openzeppelin/contracts@4.4.0/token/ERC1155/extensions/ERC1155Supply.sol";

contract MyToken is ERC1155, Ownable, Pausable, ERC1155Supply {
    constructor() ERC1155("https://trc-buckets-development.s3.amazonaws.com/crypto/{id}.json") {
        // while (Counters.current(_tokenIdCounter) < _initialSupply) {
        //     Counters.increment(_tokenIdCounter);
        //     _mint(tx.origin, Counters.current(_tokenIdCounter) - 1, 1, "");
        // }
    }

    string private _contractURI;
    Counters.Counter public _tokenIdCounter;
    uint256 private _initialSupply = 300;

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function setContractURI(string memory newuri) public onlyOwner {
        _contractURI = newuri;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount)
        public
        onlyOwner
    {
        _mint(account, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, "");
    }

    function mintAmountBatch(address to, uint256 total)
        public
        onlyOwner
        returns (uint256)
    {
        require(total > 0);
        uint256 limit = Counters.current(_tokenIdCounter) + total;
        require(limit < 999);
        
        while (Counters.current(_tokenIdCounter) < limit) {
            Counters.increment(_tokenIdCounter);
            _mint(to, Counters.current(_tokenIdCounter) - 1, 1, "");
        }

        return Counters.current(_tokenIdCounter);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}

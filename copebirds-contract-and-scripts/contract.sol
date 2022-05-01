// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract CopeBirds is ERC721, Ownable, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter public _nextTokenId;
    uint256 private _maxSupply = 666;
    uint256 private _maxPerWallet = 2;
    string private _contractURI = "https://gateway.moralisipfs.com/ipfs/QmYTXtnsrMnsACjvUJzjaFbtwbR2ivdSHWRy9QSujY3zNX/contract-metadata.json";
    string public baseURI = "ipfs://QmTRSW59m2fWNrpRGe8qN3PFp8pnUnc6e2hMshmBEo5Pgi/";

    constructor() ERC721("Cope Birds", "COPE") {}

    function setURI(string memory newuri) external onlyOwner {
        baseURI = newuri;
    }
    
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol#L93
    function _baseURI() override internal view returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory uri = super.tokenURI(tokenId);
        return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
    }

    // https://docs.opensea.io/docs/contract-level-metadata
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

    function mint(uint256 _amount)
        external
        whenNotPaused
    {
        require(_amount == 1 || _amount == 2, "Only 1 or 2 Cope Birds can be minted at the same time!");

        Counters.increment(_nextTokenId);
        if (_amount == 2) {
            Counters.increment(_nextTokenId);
        }
        require(Counters.current(_nextTokenId) <= _maxSupply, "We are sold out Cope Birds!");

        require((balanceOf(msg.sender) + _amount) <= _maxPerWallet, "Only 2 Cope Birds for address allowed!");

        _safeMint(msg.sender, Counters.current(_nextTokenId) - 1);
        if (_amount == 2) {
            _safeMint(msg.sender, Counters.current(_nextTokenId) - 2);
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

abstract contract ERC721URIStorage is ERC721 {
  mapping(uint256 => string) private _tokenURIs;

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    _requierMinted(tokenId)
    returns (string memory)
  {
    string memory _tokenURI = _tokenURIs[tokenId];
    string memory _base = _baseURI();
    if (bytes(_base).length == 0) {
      return _tokenURI;
    }
    if (bytes(_tokenURI).length > 0) {
      return string(abi.encodePacked(_base, _tokenURI));
    }

    return super.tokenURI(tokenId);
  }

  function _setTokenURI(uint256 tokenId, string memory _tokenURI)
    internal
    virtual
    _requierMinted(tokenId)
  {
    _tokenURIs[tokenId] = _tokenURI;
  }

  function _burn(uint256 tokenId) internal virtual override {
    super._burn(tokenId);

    if (bytes(_tokenURIs[tokenId]).length != 0) {
      delete _tokenURIs[tokenId];
    }
  }
}

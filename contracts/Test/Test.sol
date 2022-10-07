// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract C1 {
  function doWork() external {
    //...
  }

  function defaultValue() external view returns (address[] memory) {}
}

contract C2 {
  function run(string calldata str, string calldata str1)
    external
    pure
    returns (bytes32)
  {
    // c1.delegatecall(abi.encodeWithSignature("doWork()")); //call func like calls from contract C2
    //c1.staticcall(abi.encodeWithSignature("doWork()"));// call func only view or pure

    //bytes memory encoded = abi.encode(str, str1); // the longer result as opposed to encodedPacked
    bytes memory encoded2 = abi.encodePacked(str, str1); // the shoted result as opposed to encode
    return keccak256(encoded2);
  }

  function decode(bytes memory inp) external pure returns (string memory) {
    (string memory out, uint256 out2) = abi.decode(inp, (string, uint256)); // need to submit the data types in the correct sequence if there are several of them
    return out;
  }

  function selfdestructContract(address payable _to) external {
    selfdestruct(_to); //desctry contract, sent all funds from contract to address in function argument
  }

  fallback() external {} //is called, if a function call comes into the contract with an unknown selector (try call unknown func)

  receive() external payable {} // is called, if to contract sent money without say what function need call
}

//abi.encode
//"hello" "world" 0x40e18a9dca3f056f3d02d371c2b4cf0109ddbf43dabda342cc5989ab57c19e15
//"hell" "oworld" 0xdb4712070ffccfbfd2a780024bb12e33d238ec3f966fdb6d1f655e51044d3bbe

//encodePacked
//"hello" "world" 0xfa26db7ca85ead399216e7c6316bc50ed24393c3122b582735e7f3b0f91b93f0
//"hell" "oworld" 0xfa26db7ca85ead399216e7c6316bc50ed24393c3122b582735e7f3b0f91b93f0

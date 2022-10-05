import { ethers } from "hardhat";

async function main() {
  const password1 = ethers.utils.formatBytes32String("secret1");
  const password2 = ethers.utils.formatBytes32String("secret2");
  const password3 = ethers.utils.formatBytes32String("secret3");

  const Privacy = await ethers.getContractFactory("Privacy");
  const privacy = await Privacy.deploy([password1, password2, password3]);
  await privacy.deployed();

  console.log(privacy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

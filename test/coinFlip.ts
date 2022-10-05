import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
// eslint-disable-next-line node/no-missing-import
import { HackCoinFlip, CoinFlip } from "../typechain";

interface CoinFlipContext {
  hackCoinFlip: HackCoinFlip;
  coinFlip: CoinFlip;
  owner: SignerWithAddress;
  seller: SignerWithAddress;
  buyer: SignerWithAddress;
}

describe("Fallback", () => {
  let ctx: CoinFlipContext;

  beforeEach(async function () {
    const [owner, seller, buyer] = await ethers.getSigners();
    const CoinFlip = await ethers.getContractFactory("CoinFlip");
    const HackCoinFlip = await ethers.getContractFactory("HackCoinFlip");
    const coinFlip = await CoinFlip.deploy();
    const hackCoinFlip = await HackCoinFlip.deploy();
    ctx = { coinFlip, hackCoinFlip, owner, seller, buyer };
  });

  it("Hack contact", async () => {
    // expect(await ctx.hackCoinFlip.hack());
  });
});

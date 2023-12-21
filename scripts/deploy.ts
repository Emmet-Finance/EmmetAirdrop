import { ethers } from "hardhat";

async function main() {

  const royaltyReceiver = ""; // The royalty receiver address
  const feeNumerator = 1000; // 10%

  const emmetAirdrop = await ethers.deployContract("EmmetAirdrop", [royaltyReceiver,feeNumerator]);

  await emmetAirdrop.waitForDeployment();

  console.log(
    `Deployed to ${emmetAirdrop.target}`
  );
  process.exit(0);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

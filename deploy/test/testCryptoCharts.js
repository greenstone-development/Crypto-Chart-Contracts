const chai = require("chai");
const { solidity } = require("ethereum-waffle");

chai.use(solidity);

const main = async () => {
  const [owner] = await hre.ethers.getSigners();
  const cryptoChartsContractFactory = await hre.ethers.getContractFactory(
    "CryptoCharts"
  );
  const cryptoChartsContract = await cryptoChartsContractFactory.deploy();
  await cryptoChartsContract.deployed();
  console.log(`CryptoChart deployed to ${cryptoChartsContract.address}`);

  // Add 3 charts
  for (let i = 0; i < 3; i++) {
    const addChartTxn = await cryptoChartsContract.addChart(
      i,
      "ipfs://bafyreifuri2oezsix6722p44ulcke4pfahq6z4q7j4srjbhgu52o2yypa4/metadata.json"
    );
    await addChartTxn.wait();
  }

  // event ChartMinted(address sender, uint256 mapIndex);
  // mapIndex should match tokenId in mintChart(tokenId)
  await expect(cryptoChartsContract.mintChart(2))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 2);
  await expect(cryptoChartsContract.mintChart(0))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 0);
  await expect(cryptoChartsContract.mintChart(1))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 1);

  expect(await cryptoChartsContract.getMintedCount()).to.equal(3);

  console.log("All tests passed.");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

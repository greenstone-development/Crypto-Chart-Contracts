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
  const addChartTxn1 = await cryptoChartsContract.addChart("a");
  const addChartTxn3 = await cryptoChartsContract.addChart("c");
  const addChartTxn4 = await cryptoChartsContract.addChart("d");
  const addChartTxn2 = await cryptoChartsContract.addChart("b");
  await addChartTxn1.wait();
  await addChartTxn2.wait();
  await addChartTxn3.wait();
  await addChartTxn4.wait();

  // event ChartMinted(address sender, uint256 tokenId);
  await expect(cryptoChartsContract.mintChart(2))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 2);
  await expect(cryptoChartsContract.mintChart(0))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 0);
  await expect(cryptoChartsContract.mintChart(1))
    .to.emit(cryptoChartsContract, "ChartMinted")
    .withArgs(owner.address, 1);

  expect(await cryptoChartsContract.totalMinted()).to.eq(3);
  expect(await cryptoChartsContract.totalSupply()).to.equal(4);

  expect(await cryptoChartsContract.ipfsLinks(0)).to.equal("a");
  expect(await cryptoChartsContract.ipfsLinks(1)).to.equal("c");
  expect(await cryptoChartsContract.ipfsLinks(2)).to.equal("d");
  expect(await cryptoChartsContract.ipfsLinks(3)).to.equal("b");

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

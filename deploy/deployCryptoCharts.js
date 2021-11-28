const main = async () => {
  const cryptoChartsContractFactory = await hre.ethers.getContractFactory(
    "CryptoCharts"
  );
  const cryptoChartsContract = await cryptoChartsContractFactory.deploy();
  await cryptoChartsContract.deployed();
  console.log(`CryptoChart deployed to ${cryptoChartsContract.address}`);
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

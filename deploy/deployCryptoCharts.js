const main = async () => {
  const cryptoChartContractFactory = await hre.ethers.getContractFactory(
    "CryptoChart"
  );
  const cryptoChartContract = await cryptoChartContractFactory.deploy();
  await cryptoChartContract.deployed();
  console.log(`CryptoChart deployed to ${cryptoChartContract.address}`);
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

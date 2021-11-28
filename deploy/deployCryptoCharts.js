const main = async () => {
  const [owner] = await hre.ethers.getSigners();
  const cryptoChartsContractFactory = await hre.ethers.getContractFactory(
    "CryptoCharts"
  );
  const cryptoChartsContract = await cryptoChartsContractFactory.deploy();
  await cryptoChartsContract.deployed();

  console.log(
    `${owner.address} deployed contract to ${cryptoChartsContract.address}`
  );
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

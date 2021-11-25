// const CHAINLINK_BTCUSD_RINKEBY = "0xECe365B379E1dD183B20fc5f022230C044d51404";
// const CHAINLINK_ETHUSD_RINKEBY = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e";

const main = async () => {
  const priceConsumerFactory = await hre.ethers.getContractFactory(
    "PriceConsumerV3"
  );
  const priceConsumer = await priceConsumerFactory.deploy();
  await priceConsumer.deployed();
  console.log(`PriceConsumerV3 deployed to ${priceConsumer.address}`);

  const roundData = await priceConsumer.latestRoundData();
  // console.log(roundData.map((data) => data.toString()));
  // console.log(await priceConsumer.getRoundData(10000000));
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

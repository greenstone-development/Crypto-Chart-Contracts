const CHAINLINK_PRICE_FEED_RINKEBY =
  "0xECe365B379E1dD183B20fc5f022230C044d51404";

const main = async () => {
  const priceConsumerFactory = await hre.ethers.getContractFactory(
    "PriceConsumerV3"
  );
  const priceConsumer = await priceConsumerFactory.deploy(
    CHAINLINK_PRICE_FEED_RINKEBY
  );
  await priceConsumer.deployed();
  console.log(`PriceConsumerV3 deployed to ${priceConsumer.address}`);
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

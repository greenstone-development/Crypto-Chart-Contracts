 ## Requirements

- [NPM](https://www.npmjs.com/) or [YARN](https://yarnpkg.com/)

## About CryptoChartContracts

It is essentially a smart contract that an address  can call to mint unique bitcoin price charts and own the token to the chart.
Anyone can mint bitcoin price charts here for free!


## How to mint charts
- go to the frontend at
- connect to your wallet
- more TODOs:







## Contributing to the code

### Clone
```bash
git clone https://github.com/greenstone-development/Crypto-Chart-Contracts
cd Crypto-Chart-Contracts
```
then

### Install dependencies
```bash
npm install
```

Or

```bash
yarn
```

### Compile
```bash
npx hardhat compile
```
### Deploy

Deployment scripts are in the [deploy](https://github.com/greenstone-development/Crypto-Chart-Contracts/deploy) directory. If required, edit the desired environment specific variables or constructor parameters in each script, then run the hardhat deployment plugin as follows. If no network is specified, it will default to the Kovan network.


This will deploy to a local hardhat network

```bash
npx hardhat deploy
```

To deploy to testnet:
```bash
npx hardhat deploy --network rinkeby
```

### Test
Tests should be located in the [test](https://github.com/greenstone-development/Crypto-Chart-Contracts/test) directory, and are split between unit tests and integration tests. Unit tests should only be run on local environments, and integration tests should only run on live environments.

To run unit tests:

```bash
yarn test
```

To run integration tests:

```bash
yarn test-integration
```

### Run

The deployment output will give you the contract addresses as they are deployed. You can then use these contract addresses in conjunction with Hardhat tasks to perform operations on each contract.


### Setting Environment Variables
You can set these in your `.env` file if you're unfamiliar with how setting environment variables work. Check out our [.env example](https://github.com/greenstone-development/Crypto-Chart-Contracts/blob/main/.env.example). If you wish to use this method to set these variables, update the values in the .env.example file, and then rename it to '.env'

Don't commit and push any changes to .env files that may contain sensitive information, such as a private key! If this information reaches a public GitHub repository, someone can use it to check if you have any Mainnet funds in that wallet address, and steal them!

If you plan on deploying to a local [Hardhat network](https://hardhat.org/hardhat-network/) that's a fork of the Ethereum mainnet instead of a public test network like Kovan, you'll also need to set your `MAINNET_RPC_URL` [environment variable.](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html) and uncomment the `forking` section in `hardhat.config.js`. You can get one for free at [Alchemy's site.](https://alchemyapi.io/).

You can also use a `PRIVATE_KEY` instead of a `MNEMONIC` environment variable by uncommenting the section in the `hardhat.config.js`, and commenting out the `MNEMONIC` line.


## Chainlink Price Feeds
The Price Feeds consumer contract has one task, to read the latest price of a specified price feed contract

```bash
npx hardhat read-price-feed --contract insert-contract-address-here --network network
```

## Verify on Etherscan

You'll need an `ETHERSCAN_API_KEY` environment variable. You can get one from the [Etherscan API site.](https://etherscan.io/apis)

```
npx hardhat verify --network <NETWORK> <CONTRACT_ADDRESS> <CONSTRUCTOR_PARAMETERS>
```
example:

```
npx hardhat verify --network rinkeby 0x9279791897f112a41FfDa267ff7DbBC46b96c296 "0x9326BFA02ADD2366b30bacB125260Af641031331"
```

sometimes verifying may give you a bizarre error  that looks like this 
[Error: ENOENT: no such file or directory, open '/Users/<user>/<directory>/NFT-demos/crypto-charts-contracts/artifacts/build-info/d4c83a0b3e1f40f4c5980f3173aa6683.json']

just run

```
npx hardhat clean

```
and try to verify again

### Linting

```
yarn lint:fix
```

let {networkConfig} = require('../helper-hardhat-config')

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId
}) => { 

  const { deploy, get, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = await getChainId()
  let ownerAddress="0x288b78634fD388aFd2Df5244Be3e1D8d265E447b"
  let tokenURI ="https://gateway.pinata.cloud/ipfs/QmXRksE99CTW8yu6KyzsjKucS7GF2bznLmxkW1npZKkFoF";
  

  const CryptoChart = await deploy('CryptoChart', {
    from: deployer,
    args: [ownerAddress, tokenURI], 
    log: true
  })

 
  log("To generate a character run the following:")
  log("npx hardhat generate-character --contract " + CryptoChart.address + " --name InsertNameHere " +  " --network " + networkConfig[chainId]['name'])
  log("To get a character's details as metadata run the following:")
  log("npx hardhat create-metadata --contract " +CryptoChart.address + " --network " + networkConfig[chainId]['name'])
  log("----------------------------------------------------")
}

module.exports.tags = ['all', 'priceChart']

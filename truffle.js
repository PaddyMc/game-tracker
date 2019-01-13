// var HDWalletProvider = require("truffle-hdwallet-provider");
// var mnemonic = "opinion destroy betray ...";

const networks = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    // rinkbey: {
    //   provider: () => { 
    //     return new HDWalletProvider(mnemonic, 'https://rinkbey.infura.io/') 
    //   },
    //   network_id: '4',
    //   gas: 4500000,
    //   gasPrice: 10000000000,
    // }
  }
};

module.exports = networks

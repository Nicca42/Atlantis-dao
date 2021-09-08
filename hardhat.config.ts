require('hardhat-contract-sizer');
require('hardhat-docgen');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.5",
        settings: {}
      }
    ]
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false
  },
  docgen: {
    path: './docs/gen-docs',
    clear: true,
    runOnCompile: true
  }
};

const { buildModule } = require('@nomicfoundation/hardhat-ignition/modules');

module.exports = buildModule('PharmacyChain', (m) => {
  const pharmacy = m.contract('PharmacyChain');
  return { pharmacy };
});

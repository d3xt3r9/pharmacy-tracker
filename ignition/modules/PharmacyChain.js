const { buildModule } = require('@nomicfoundation/hardhat-ignition/modules');

module.exports = buildModule('PharmacyChain', (m) => {
  const pharmacy = m.contract('PharmacyChain');

  const thanos = m.call(pharmacy, 'addParticipant', ['0x90f79bf6eb2c4f870365e785982e1f101e93b906', 1, 'User_Supplier_1', 'User_Supplier_1@pharmachain.com']);
  // m.call(pharmacy, 'addParticipant', ['0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65', 2, 'LogisticEmployee_1', 'LogisticEmployee_1@pharmachain.com']);
  // m.call(pharmacy, 'addParticipant', ['0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc', 3, 'Controller_1', 'Controller_1@pharmachain.com']);
  // m.call(pharmacy, 'getParticipant', ['0x90f79bf6eb2c4f870365e785982e1f101e93b906']);
  // m.call(pharmacy, 'addProduct', ['depon', 1, 1], {
  //   value: 100_000_000_000_000_000n, // 0,1 ETH
  // });

  return { pharmacy };
});

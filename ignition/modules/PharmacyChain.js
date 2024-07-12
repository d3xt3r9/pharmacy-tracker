const { buildModule } = require('@nomicfoundation/hardhat-ignition/modules');

module.exports = buildModule('PharmacyChain', (m) => {
  const pharmacy = m.contract('PharmacyChain');

  // const thanos = m.call(pharmacy, 'addParticipant', ['0x90f79bf6eb2c4f870365e785982e1f101e93b906', 1, 'User_Supplier_1', 'User_Supplier_1@pharmachain.com']);
  // m.call(pharmacy, 'addParticipant', ['0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65', 2, 'LogisticEmployee_1', 'LogisticEmployee_1@pharmachain.com']);
  // m.call(pharmacy, 'addParticipant', ['0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc', 3, 'Controller_1', 'Controller_1@pharmachain.com']);
  // m.call(pharmacy, 'getParticipant', ['0x90f79bf6eb2c4f870365e785982e1f101e93b906']);
  // m.call(pharmacy, 'addProduct', ['depon', 1, 1], {
  //   value: 100_000_000_000_000_000n, // 0,1 ETH
  // });

  m.call(pharmacy, 'addUser', ['0x70997970C51812dc3A010C7d01b50e0d17dc79C8', 'Athanasios', 'User_Supplier_1@mypharmachain.gr', 2]);

  // m.call(pharmacy, 'getUserRole', ['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266']);

  m.call(pharmacy, 'addProduct', [1, 'DEPON', 9]);

  // const myproduct = m.call(pharmacy, 'getProduct', [1]);

  return { pharmacy };
});

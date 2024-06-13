const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PharmaSupplyChain', function () {
  let PharmaSupplyChain;
  let pharmaSupplyChain;
  let admin, supplier, logisticEmployee, controller;

  before(async function () {
    [admin, supplier, logisticEmployee, controller] = await ethers.getSigners();

    // Deploy the contract
    PharmaSupplyChain = await ethers.getContractFactory('PharmaSupplyChain');
    pharmaSupplyChain = await PharmaSupplyChain.deploy();
    await pharmaSupplyChain.waitForDeployment();

    // Set roles only once
    await pharmaSupplyChain.addUser(supplier.address, 'Supplier');
    await pharmaSupplyChain.addUser(logisticEmployee.address, 'LogisticEmployee');
    await pharmaSupplyChain.addUser(controller.address, 'Controller');
  });

  describe('Deployment', function () {
    it('Should set the correct admin', async function () {
      expect(await pharmaSupplyChain.admin()).to.equal(admin.address);
    });

    it('Should assign the correct roles', async function () {
      expect(await pharmaSupplyChain.userRoles(supplier.address)).to.equal(1); // Supplier role
      expect(await pharmaSupplyChain.userRoles(logisticEmployee.address)).to.equal(2); // LogisticEmployee role
      expect(await pharmaSupplyChain.userRoles(controller.address)).to.equal(3); // Controller role
    });
  });

  describe('Product Management', function () {
    it('Should allow supplier to add products', async function () {
      await pharmaSupplyChain.connect(supplier).addProduct('Paracetamol', 'Supplier Warehouse');
      const product = await pharmaSupplyChain.products(1);
      expect(product.name).to.equal('Paracetamol');
      expect(product.currentLocation).to.equal('Supplier Warehouse');
    });
  });

  describe('Shipment Management', function () {
    beforeEach(async function () {
      await pharmaSupplyChain.connect(supplier).addProduct('Paracetamol', 'Supplier Warehouse');
    });

    it('Should allow logistic employee to add shipments', async function () {
      await pharmaSupplyChain.connect(logisticEmployee).addShipment(1, 'Supplier Warehouse', 'Central Warehouse', 1623967200, 1626562800);
      const shipment = await pharmaSupplyChain.shipments(1);
      expect(shipment.origin).to.equal('Supplier Warehouse');
      expect(shipment.destination).to.equal('Central Warehouse');
    });

    it('Should allow logistic employee to update shipment status', async function () {
      await pharmaSupplyChain.connect(logisticEmployee).addShipment(1, 'Supplier Warehouse', 'Central Warehouse', 1623967200, 1626562800);
      await pharmaSupplyChain.connect(logisticEmployee).updateShipment(1, 'Delivered');
      const shipment = await pharmaSupplyChain.shipments(1);
      expect(shipment.status).to.equal('Delivered');
    });
  });
});

<template>
  <div>
    <h1>Product List</h1>
    <ul>
      <li v-for="product in products" :key="product.productId">{{ product.name }} - {{ product.quantity }} - {{ product.location }}</li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { ethers } from 'ethers';

const products = ref([]);

function listenForProductAdded(contract) {
  contract.on('ProductAdded', (productId, name, owner, quantity, location) => {
    products.value.push({
      productId: productId.toNumber(),
      name,
      owner,
      quantity: quantity.toNumber(),
      location,
    });
    console.log(`Product Added - ID: ${productId}, Name: ${name}, Owner: ${owner}, Quantity: ${quantity}, Location: ${location}`);
  });
}

onMounted(async () => {
  const provider = new ethers.JsonRpcProvider('http://localhost:8545'); // Local network
  const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  const abi = [
    'event ProductAdded(uint256 productId, string name, address owner, uint256 quantity, string location)',
    'function addParticipant(address _participant, uint8 _role) public',
    'function addProduct(string memory _name, uint256 _quantity, string memory _location) public payable',
    'function getProduct(uint256 _productId) public view returns (tuple(string name, address currentOwner, uint256 quantity, string location, tuple(address from, address to, uint256 timestamp, string location, uint256 quantity)[] shippingHistory) memory)',
    'function productCounter() public view returns (uint256)',
  ];

  const contract = new ethers.Contract(contractAddress, abi, provider);

  listenForProductAdded(contract);
});
</script>

<style scoped>
h1 {
  color: #2c3e50;
}
</style>

<template>
  <div>
    <h2>Product Added Events</h2>
    <ul>
      <li v-for="product in products" :key="product.productId">
        <strong>Product ID:</strong> {{ product.productId }} <br />
        <strong>Name:</strong> {{ product.name }} <br />
        <strong>Owner:</strong> {{ product.owner }} <br />
        <strong>Quantity:</strong> {{ product.quantity }} <br />
        <strong>Location:</strong> {{ product.location }} <br />
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { ethers } from 'ethers';
import { contractAddress, contractABI } from '../helpers/ContractFunctions.vue';

const provider = new ethers.BrowserProvider(window.ethereum);
const contract = new ethers.Contract(contractAddress, contractABI, provider);
const products = ref([]);

const handleProductAdded = (productId, name, owner, quantity, location) => {
  products.value.push({
    productId: productId.toString(),
    name,
    owner,
    quantity: quantity.toString(),
    location: location.toString(),
  });
  console.log(`Product Added - ID: ${productId}, Name: ${name}, Owner: ${owner}, Quantity: ${quantity}, Location: ${location}`);
};

// Step 7: Register and unregister the event listener
onMounted(() => {
  contract.on('ProductAdded', handleProductAdded);
});

onUnmounted(() => {
  contract.off('ProductAdded', handleProductAdded);
});
</script>

<style scoped>
ul {
  list-style-type: none;
  padding: 0;
}

li {
  margin-bottom: 1em;
  padding: 1em;
  border: 1px solid #ccc;
  border-radius: 5px;
}
</style>

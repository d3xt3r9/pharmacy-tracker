<template>
  <div class="flex">
    <!-- Sidebar -->
    <aside class="w-1/4 p-4 border-r border-gray-200">
      <h3 class="text-lg font-semibold mb-4">Available Products</h3>
      <ul>
        <li v-for="product in products" :key="product.productId" class="mb-4">
          <div class="mb-2">
            <span class="font-semibold">{{ product.name }}</span>
            <span class="text-sm text-gray-500"> - Quantity: {{ product.quantity }}</span>
          </div>
          <div class="text-sm text-gray-600">
            <div>Owner: {{ product.currentOwner }}</div>
            <div>Location: {{ getLocationName(product.location) }}</div>
          </div>
        </li>
      </ul>
    </aside>
    <!-- Main Content -->
    <main class="w-3/4 p-4">
      <h2>Add Product</h2>

      <form @submit.prevent="addaProduct" class="mt-4">
        <div class="mb-4">
          <label for="productName" class="block text-sm font-medium text-gray-700">Product Name</label>
          <input
            v-model="productName"
            type="text"
            id="productName"
            name="productName"
            class="mt-1 p-2 block w-full border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>

        <div class="mb-4">
          <label for="productQuantity" class="block text-sm font-medium text-gray-700">Quantity</label>
          <input
            v-model.number="productQuantity"
            type="number"
            id="productQuantity"
            name="productQuantity"
            class="mt-1 p-2 block w-full border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>

        <div class="mb-4">
          <label for="productLocation" class="block text-sm font-medium text-gray-700">Location</label>
          <select
            v-model.number="productLocation"
            id="productLocation"
            name="productLocation"
            class="mt-1 p-2 block w-full border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          >
            <option value="0">Manufacturer</option>
            <option value="1">Supplier</option>
            <option value="2">Logistic Warehouse</option>
            <option value="3">Pharmacy</option>
          </select>
        </div>

        <button type="submit" class="bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600 transition-colors duration-300 w-full">
          Add Product
        </button>
      </form>

      <h2 class="mt-8">Product List</h2>
      <button @click="getit" class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-full">
        Disconnect
      </button>
    </main>
  </div>
</template>

<script setup>
import { ethers } from 'ethers';
import { ref, onMounted } from 'vue';
import { addProduct, getProductbyid } from '../helpers/ContractFunctions.vue';

const productName = ref('');
const productQuantity = ref(0);
const productLocation = ref(0); // Default to Manufacturer, adjust as needed

const products = ref([]);

async function addaProduct() {
  const txhash = await addProduct(productName, productQuantity, productLocation);
  console.log('Transaction Hash:', txhash);
}

async function getit() {
  const product = await getProductbyid(3);
  console.log('Product:', product);
}

// async function addProduct() {
//   const signer = await nprovider.getSigner();
//   const signerAddress = await signer.getAddress();

//   const addProductFee = ethers.parseEther('0.01'); // 0.01 Ether

//   console.log('Signer:', signerAddress);

//   const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

//   try {
//     const tx = await contractWithSigner.addProduct(productName.value, productQuantity.value, productLocation.value, {
//       value: addProductFee,
//       gasLimit: 30000000,
//     });
//     await tx.wait();
//     console.log('Transaction Hash:', tx.hash);
//     // Reset form fields after successful transaction
//     productName.value = '';
//     productQuantity.value = 0;
//     productLocation.value = 0;
//     await fetchProducts(); // Refresh product list after adding new product
//   } catch (error) {
//     console.error('Error:', error);
//   }
// }

// async function fetchProducts() {
//   const contract = new ethers.Contract(contractAddress, contractABI, nprovider);

//   try {
//     const totalProducts = await contract.productCounter();
//     const productsArray = [];
//     for (let i = 0; i < totalProducts; i++) {
//       const product = await contract.products(i);
//       productsArray.push({
//         productId: i,
//         name: product.name,
//         currentOwner: product.currentOwner,
//         quantity: product.quantity,
//         location: product.location,
//       });
//     }
//     products.value = productsArray;
//   } catch (error) {
//     console.error('Error fetching products:', error);
//   }
// }

// function getLocationName(locationIndex) {
//   const locations = ['Manufacturer', 'Supplier', 'Logistic Warehouse', 'Pharmacy'];
//   return locations[locationIndex];
// }

onMounted(() => {});
</script>

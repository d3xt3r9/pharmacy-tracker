<template>
  <Menu />
  <div class="flex my-8 p-4">
    <!-- Sidebar -->
    <aside class="w-1/4 border-r border-gray-200">
      <div class="flex justify-center my-8">
        <button @click="getProducts" class="bg-green-800 text-white rounded hover:bg-green-700 transition-colors duration-300 font-semibold p-3 rounded">
          Refresh Product List
        </button>
      </div>
      <h3 class="text-lg font-semibold">Available Products</h3>

      <ul>
        <li v-for="product in products" :key="product.productId" class="p-2 rounded border rounded">
          <div class="mb-1 flex space-x-1">
            <span class="bg-sky-500 font-bold text-white p-1 rounded">id: {{ product.productId }}</span>
            <span class="p-1 font-bold">{{ product.name }}</span>
            <span class="p-1 font-semibold">| Quantity: {{ product.quantity }}</span>
          </div>
        </li>
      </ul>
    </aside>
    <!-- Main Content -->
    <main class="w-3/4 px-4">
      <h2 class="text-sky-900 text-center text-2xl font-bold">Add Product</h2>

      <form @submit.prevent="addProduct" class="mt-4 m-12 p-12">
        <div class="mb-4">
          <label for="productID" class="block text-sm font-medium text-gray-700">Product ID</label>
          <input
            v-model="productID"
            type="text"
            id="productID"
            name="productID"
            class="mt-1 p-2 block w-full border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>
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

        <button type="submit" class="bg-green-900 text-white font-bold py-2 px-4 rounded hover:bg-green-800 transition-colors duration-300 w-full">
          Add Product
        </button>
      </form>
    </main>
  </div>
</template>

<script setup>
import Menu from '@/components/Menu.vue';
import { ref, onMounted } from 'vue';
import { addProducToPharmaChain, getProductbyidFromPharmaChain, getProductsId } from '../helpers/ContractFunctions.vue';

const productID = ref(0);
const productName = ref('');
const productQuantity = ref(0);
const products = ref([]);

async function addProduct() {
  const txhash = await addProducToPharmaChain(productID, productName, productQuantity);
  console.log('Transaction Hash:', txhash);
}

async function getProducts() {
  const productsList = [];

  const ids = await getProductsId();

  for (const id of ids) {
    const productInfo = await getProductbyidFromPharmaChain(id[0]);
    console.log(productInfo);
    const productObject = {
      productId: id[0],
      name: productInfo[0],
      quantity: productInfo[1],
      currentowner: productInfo[2],
      location: productInfo[3],
      shippinghistory: productInfo[4],
    };
    const temp = productInfo[4];
    console.log(temp[0]);
    productsList.push(productObject);
  }
  products.value = productsList;
}

onMounted(async () => {
  await getProducts();
});
</script>

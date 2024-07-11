<template>
  <Menu />
  <div class="flex justify-center mt-4">
    <button @click="getProducts" class="bg-green-800 text-white rounded hover:bg-green-700 transition-colors duration-300 font-semibold p-3 rounded">
      Refresh Product List
    </button>
  </div>
  <div class="p-4 flex flex-wrap gap-4">
    <div v-for="product in products" :key="product" class="p-2 rounded border rounded">
      <div class="text-left">
        <b class="bg-green-500 text-white p-1 rounded mt-4">id: {{ product.productId }} </b>
      </div>
      <h1 class="text-center text-xl font-bold p-2">
        <b>{{ product.name }}</b>
      </h1>
      <p>Quantity: {{ product.quantity }}</p>
      <p>Owner: {{ product.currentowner }}</p>
      <p v-if="product.location == 1">Location: Manufacturer</p>
      <p v-else-if="product.location == 2">Location: Supplier</p>
      <p v-else-if="product.location == 3">Location: LogisticWarehouse</p>
      <p v-else-if="product.location == 4">Location: Courier</p>
      <p v-else-if="product.location == 5">Location: Pharmacy</p>
      <div v-for="History in product.shippinghistory">
        <p class="bg-blue-500 text-center text-l text-white p-1 rounded mt-4">Transfer ID: {{ History[0] }}</p>
        <p v-if="History[3] == 1">Location: Manufacturer</p>
        <p v-else-if="History[3] == 2">Location: Supplier</p>
        <p v-else-if="History[3] == 3">Location: LogisticWarehouse</p>
        <p v-else-if="History[3] == 4">Location: Courier</p>
        <p v-else-if="History[3] == 5">Location: Pharmacy</p>
        <p>makeTransfer: {{ History[1] }}</p>
        <p>Timestamp: {{ History[2] }}</p>
        <p>Quantity: {{ History[4] }}</p>
      </div>
      <button @click="deleteProduct(product.productId)" class="bg-red-500 text-white p-2 rounded">Delete Product</button>
    </div>
  </div>
</template>

<script setup>
import Menu from '@/components/Menu.vue';
import { ref, onMounted } from 'vue';
import { getProductsId, removeProduct, getProductbyidFromPharmaChain } from '../helpers/ContractFunctions.vue';

const productID = ref(0);
const products = ref([]);

onMounted(async () => {
  await getProducts();
});

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

async function deleteProduct(currentProductID) {
  console.log(currentProductID);
  const txID = await removeProduct(currentProductID);
  console.log(txID);
  return;
}
</script>

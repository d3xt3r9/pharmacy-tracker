<template>
  <div
    :class="{
      'grid grid-cols-2 md:grid-cols-2 gap-4 md:gap-8 items-center justify-center min-h-screen bg-gray-100 p-4 md:p-8': !isConnected,
      'grid grid-cols-1 gap-4 md:gap-8 items-center justify-center min-h-screen bg-gray-100 p-4 md:p-8': isConnected,
    }"
  >
    <!--  Right Column - Welcome Message -->
    <div class="text-center">
      <h1 v-if="!isConnected" class="text-4xl font-bold mb-2 md:mb-4 text-blue-600">Welcome to Pharmacy Supply Chain</h1>
      <p v-if="!isConnected" class="text-lg mb-2 md:mb-4">Manage your products securely with blockchain technology.</p>
      <button
        v-if="!isConnected"
        @click="connectWallet"
        class="bg-blue-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600 transition-colors duration-300"
      >
        Connect to MetaMask
      </button>
      <div v-else>
        <h1 class="text-4xl font-bold mb-2 md:mb-4 text-blue-600">Welcome to Pharmacy Supply Chain</h1>
        <p class="text-lg mb-2">Wallet Connected:</p>
        <p class="text-lg font-semibold mb-4">{{ address }}</p>
        <p class="text-lg mb-2">Role: {{ userrole }}</p>
      </div>
    </div>
    <div class="text-center" :class="{ 'mb-2 md:mb-4': !isConnected }">
      <div v-if="isConnected">
        <div class="space-y-4">
          <h2 class="text-2xl font-bold mb-2 md:mb-4">Actions</h2>
          <button @click="addUser" class="bg-blue-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600 transition-colors duration-300 w-full">
            Add User
          </button>
          <button @click="deleteUser" class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-full">
            Delete User
          </button>
          <button @click="addProduct" class="bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600 transition-colors duration-300 w-full">
            Add Product
          </button>
          <button @click="deleteProduct" class="bg-yellow-500 text-white font-bold py-2 px-4 rounded hover:bg-yellow-600 transition-colors duration-300 w-full">
            Delete Product
          </button>
          <button @click="disconnectWallet" class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-full">
            Disconnect
          </button>
        </div>
      </div>
      <div v-else>
        <img src="../assets/pharmacycover.jpg" alt="Connected Image" class="mx-auto rounded-full w-80 object-cover" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted, onActivated } from 'vue';
import { connectWallet, disconnectWallet, isConnected } from '../helpers/WalletHelper.vue';
import { getMyInfo } from '../helpers/ContractFunctions.vue';

const router = useRouter();

const userrole = ref(null);
const address = ref(null);

onMounted(async () => {
  const userInfo = await getMyInfo();

  if (isConnected.value && userInfo !== null) {
    isConnected.value = true;

    userrole.value = userInfo[3];
    address.value = userInfo[0];

    console.log('User Role:', userInfo);
  }
});

function addProduct() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/addproduct');
}
function deleteProduct() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/deleteproduct');
}

function addUser() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/addUser');
}

function deleteUser() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/deleteUser');
}
</script>

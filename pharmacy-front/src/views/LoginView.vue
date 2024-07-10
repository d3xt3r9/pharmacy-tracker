<template>
  <div class="grid grid-cols-2 md:grid-cols-2 gap-4 md:gap-8 items-center justify-center min-h-screen bg-gray-100 p-4 md:p-8">
    <div class="text-center">
      <h1 class="text-4xl font-bold mb-2 md:mb-4 text-blue-600">Welcome to Pharmacy Supply Chain</h1>
      <p class="text-lg mb-2 md:mb-4">Manage your products securely with blockchain technology.</p>
      <button @click="connect" class="bg-blue-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600 transition-colors duration-300">
        Connect to MetaMask
      </button>
    </div>
    <div>
      <img src="../assets/pharmacycover.jpg" alt="Connected Image" class="mx-auto rounded-full w-80 object-cover" />
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted, onActivated } from 'vue';
import { connectWallet, isConnected } from '../helpers/WalletHelper.vue';

const router = useRouter();

const userrole = ref(null);
const address = ref(null);

onMounted(async () => {});

async function connect() {
  const connection = await connectWallet();

  if (connection == true) {
    router.push('/home');
  } else {
    alert('Please install MetaMask and try again.');
  }
}
</script>

<template>
  <div class="grid grid-cols-2 md:grid-cols-2 gap-4 md:gap-4 items-center justify-center min-h-screen bg-gray-100 p-8 md:p-8">
    <div class="text-center">
      <h1 class="text-5xl font-bold mb-2 md:mb-4 text-sky-800">Pharmacy Supply Chain</h1>
      <h2 class="text-2xl font-bold mb-2 md:mb-4 text-sky-700">Secure - Transparent - Efficient.</h2>

      <p class="text-lg mb-2 md:mb-8 px-8 m-8">
        Manage your pharmaceutical products securely with blockchain technology. Ensure transparency, efficiency, and compliance throughout your supply chain.
      </p>
      <button @click="connect" class="bg-sky-600 text-white font-bold py-2 px-4 rounded hover:bg-sky-500 transition-colors duration-300">
        Connect to MetaMask
      </button>
    </div>
    <div>
      <img
        src="../assets/pharmachain.svg"
        alt="Connected Image"
        class="mx-auto rounded-full w-96 h-96 object-cover shadow-lg transition-transform transform hover:scale-110 hover:shadow-2xl duration-300 ease-in-out"
      />
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted } from 'vue';
import { connectWallet } from '../helpers/WalletHelper.vue';

const router = useRouter();

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

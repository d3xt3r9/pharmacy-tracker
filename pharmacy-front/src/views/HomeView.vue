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
    <!-- Left Column - Image and Actions -->
    <div class="text-center" :class="{ 'mb-2 md:mb-4': !isConnected }">
      <div v-if="isConnected">
        <div class="space-y-4">
          <h2 class="text-2xl font-bold mb-2 md:mb-4">Actions</h2>
          <button @click="addProduct" class="bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600 transition-colors duration-300 w-full">
            Add Product
          </button>
          <button @click="getProduct" class="bg-yellow-500 text-white font-bold py-2 px-4 rounded hover:bg-yellow-600 transition-colors duration-300 w-full">
            Get Product
          </button>
          <button @click="disconnectWallet" class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-full">
            Disconnect
          </button>
          <!-- Additional actions buttons can be added here -->
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
import { ref, onMounted } from 'vue';
import { ethers } from 'ethers';
import { connectWallet, disconnectWallet, getUserWallet, isConnected } from '../helpers/WalletHelper.vue';
import { getUserRole, liveproductUpdates } from '../helpers/ContractFunctions.vue';

const router = useRouter();

const userrole = ref(null);
const address = ref(null);

onMounted(async () => {
  if (isConnected.value) {
    isConnected.value = true;
    userrole.value = await getUserRole();
    address.value = await getUserWallet();
    liveproductUpdates();
  }
});

function addProduct() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/addproduct');
}

// const provider = new ethers.JsonRpcProvider(`http://localhost:8545`);
// const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
// const contractABI = [
//   'function addProduct(string, uint256, string) public payable',
//   'function getProduct(uint256 _productId) public view returns (tuple(string name, address currentOwner, uint256 quantity, string location, tuple(address from, address to, uint256 timestamp, string location, uint256 quantity)[] shippingHistory) memory)',
//   'event ProductAdded(uint256 productId, string name, address owner, uint256 quantity, string location)',
// ];
// My Contract with ABI
// const contract = new ethers.Contract(contractAddress, contractABI, provider);

// const userAddress = ref(localStorage.getItem('userAddress') || null);
// const isConnected = ref(userAddress.value !== null);

// async function connectWallet() {
//   if (window.ethereum) {
//     try {
//       const accounts = await window.ethereum.request({
//         method: 'eth_requestAccounts',
//       });

//       userAddress.value = accounts[0];
//       localStorage.setItem('userAddress', userAddress.value);
//       isConnected.value = true;
//     } catch (error) {
//       console.error('User rejected the request:', error);
//     }
//   } else {
//     alert('MetaMask is not installed. Please install MetaMask and try again.');
//   }
// }

// async function getProduct() {
//   const nprovider = new ethers.BrowserProvider(window.ethereum);
//   const signer = await nprovider.getSigner();
//   const signerAddress = await signer.getAddress();

//   const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

//   const productId = 1;
//   const product = await contractWithSigner.getProduct(productId);
//   console.log(product);
// }

// async function addProduct() {
//   const nprovider = new ethers.BrowserProvider(window.ethereum);
//   const signer = await nprovider.getSigner();
//   const signerAddress = await signer.getAddress();

//   const addProductFee = ethers.parseEther('0.01'); // 0.01 Ether

//   console.log('Signer:', signerAddress);

//   const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

//   try {
//     const tx = await contractWithSigner.addProduct('Product Name', 100, 'Product Description', {
//       value: addProductFee,
//     });
//     console.log(tx);
//   } catch (error) {
//     console.error('Error:', error);
//   }
// }
</script>

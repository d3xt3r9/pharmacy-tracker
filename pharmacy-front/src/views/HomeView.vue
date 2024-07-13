<template>
  <Menu />
  <div class="flex flex-col items-center justify-center bg-cover bg-center bg-gray-50 p-4 md:p-8 space-y-2">
    <!-- Welcome Message -->
    <div class="text-center w-full max-w-3xl">
      <div class="bg-white bg-opacity-80 shadow-xl rounded-lg p-8 md:p-12">
        <h1 class="text-4xl md:text-3xl font-extrabold mb-6 text-sky-900">
          Welcome <span class="font-semibold text-sky-900">{{ name }}</span>
        </h1>
        <div class="text-left space-y-2">
          <p class="text-sky-700 text-lg md:text-xl"><span class="font-semibold text-sky-900">Wallet:</span> {{ address }}</p>
          <p class="text-sky-700 text-lg md:text-xl"><span class="font-semibold text-sky-900">Email:</span> {{ email }}</p>
          <p class="text-sky-700 text-lg md:text-xl"><span class="font-semibold text-sky-900">Role:</span> {{ userrole }}</p>
        </div>
      </div>
    </div>

    <!-- Actions -->
    <div class="text-center w-full max-w-3xl">
      <div class="bg-white bg-opacity-80 shadow-xl rounded-lg p-6 md:p-8">
        <div v-if="isConnected">
          <h2 class="text-2xl text-sky-900 font-bold mb-4">ACTIONS MENU</h2>
          <div class="space-y-4">
            <button
              v-if="userrole == 'Administrator'"
              @click="addUser"
              class="bg-blue-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Add User
            </button>
            <button
              v-if="userrole == 'Administrator'"
              @click="deleteUser"
              class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Delete User
            </button>
            <button
              v-if="userrole == 'Administrator'"
              @click="addProduct"
              class="bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Add Product
            </button>
            <button
              v-if="userrole == 'Administrator'"
              @click="deleteProduct"
              class="bg-yellow-500 text-white font-bold py-2 px-4 rounded hover:bg-yellow-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Delete Product
            </button>

            <button
              v-if="userrole != 'Administrator'"
              @click="transfer"
              class="bg-cyan-500 text-white font-bold py-2 px-4 rounded hover:bg-cyan-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Transfer Product
            </button>
            <button
              @click="disconnectWallet"
              class="bg-red-500 text-white font-bold py-2 px-4 rounded hover:bg-red-600 transition-colors duration-300 w-3/4 mx-auto"
            >
              Disconnect
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Menu from '@/components/Menu.vue';
import { useRouter } from 'vue-router';
import { ref, onMounted } from 'vue';
import { isConnected } from '../helpers/WalletHelper.vue';
import { getMyInfo } from '../helpers/ContractFunctions.vue';

const router = useRouter();

const address = ref(null);
const name = ref(null);
const email = ref(null);
const userrole = ref(null);

onMounted(async () => {
  if (await getMyInfo()) {
    isConnected.value = true;
    const userInfo = await getMyInfo();

    address.value = userInfo[0];
    name.value = userInfo[1];
    email.value = userInfo[2];
    userrole.value = userInfo[3];
  } else {
    router.push('/');
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

function transfer() {
  if (!isConnected.value) {
    alert('Please connect your wallet first.');
    return;
  }
  router.push('/transfer');
}

function disconnectWallet() {
  router.push('/');
}
</script>

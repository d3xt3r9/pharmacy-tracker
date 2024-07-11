<template>
  <Menu />
  <div class="flex h-full mx-20">
    <!-- User List Column -->
    <aside class="bg-white border-r w-1/8 p-2 m-4">
      <div class="flex justify-center mt-4">
        <button @click="getUsers" class="bg-green-800 text-white rounded hover:bg-green-700 transition-colors duration-300 font-semibold p-3 rounded">
          Refresh Users List
        </button>
      </div>
      <div class="py-4 grid grid-cols-2 gap-2">
        <div v-for="user in users" :key="user.wallet" class="p-4 rounded text-left border">
          <h2 class="font-bold">{{ user.name }}</h2>
          <h2>{{ user.wallet }}</h2>
          <p>Email: {{ user.email }}</p>
          <p>Role: {{ user.role }}</p>
        </div>
      </div>
    </aside>
    <!-- Form Column -->
    <main class="flex-1 p-2">
      <div class="bg-white p-6 rounded-lg shadow-lg">
        <h2 class="text-2xl font-bold mb-4">Add New User</h2>
        <form @submit.prevent="addParticipant">
          <div class="mb-4">
            <label class="block text-gray-700">Wallet</label>
            <input v-model="participantwallet" type="text" class="w-full p-2 border rounded" required />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Name</label>
            <input v-model="name" type="text" class="w-full p-2 border rounded" required />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Email</label>
            <input v-model="email" type="email" class="w-full p-2 border rounded" required />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Role</label>
            <select v-model="role" class="w-full p-2 border rounded">
              <option value="1">Administrator</option>
              <option value="2">Supplier</option>
              <option value="3">Logistic Employee</option>
              <option value="4">Controller</option>
            </select>
          </div>
          <button type="submit" class="bg-blue-500 text-white p-2 rounded">Add Participant</button>
        </form>
      </div>
    </main>
  </div>
</template>

<script setup>
import Menu from '@/components/Menu.vue';
import { ref, onMounted } from 'vue';
import { createUser, getUsersWallet, getUsersInfo } from '../helpers/ContractFunctions.vue';

const participantwallet = ref('');
const name = ref('');
const email = ref('');
const role = ref(0);
const users = ref([]);

onMounted(async () => {
  await getUsers();
});

async function getUsers() {
  const usersList = [];

  const wallets = await getUsersWallet();

  for (const wallet of wallets) {
    const userInfo = await getUsersInfo(wallet[0]);
    const userObject = {
      wallet: wallet[0],
      name: userInfo[0],
      email: userInfo[1],
      role: userInfo[2],
    };
    usersList.push(userObject);
  }
  users.value = usersList;
}
async function addParticipant() {
  await createUser(participantwallet, role, name, email);
  participantwallet.value = '';
  name.value = '';
  email.value = '';
  role.value = 0;
}
</script>

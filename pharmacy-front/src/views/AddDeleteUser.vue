<template>
  <div class="flex w-full">
    <!-- Sidebar -->
    <aside class="w-64 bg-white border-r flex-shrink-0">
      <h2 class="text-xl font-bold p-4 border-b">Users</h2>
      <ul class="p-4">
        <li v-for="user in users" :key="user" class="p-2 border-b">
          {{ user }}
        </li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-6">
      <div class="bg-white p-6 rounded-lg shadow-lg">
        <h2 class="text-2xl font-bold mb-4">Add Participant</h2>
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
              <option value="0">Administrator</option>
              <option value="1">Supplier</option>
              <option value="2">LogisticEmployee</option>
              <option value="3">Controller</option>
              <!-- Add more roles as needed -->
            </select>
          </div>
          <button type="submit" class="bg-blue-500 text-white p-2 rounded">Add Participant</button>
        </form>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { addUser, getUsers } from '../helpers/ContractFunctions.vue';

const participantwallet = ref('');
const name = ref('');
const email = ref('');
const role = ref(0);
const users = ref([]);

async function addParticipant() {
  //   console.log(participantwallet.value, role.value, name.value, email.value);
  await addUser(participantwallet, role, name, email);
  users.value.push(name.value);
  participantwallet.value = '';
  name.value = '';
  email.value = '';
  role.value = 0;
}

onMounted(() => {
  // Fetch users from the database

  getUsers();

  users.value = ['Alice', 'Bob', 'Charlie'];
});
</script>

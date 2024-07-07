<template>
  <aside class="bg-white border-r flex-shrink-0">
    <h2 class="text-xl font-bold p-4 border-b">Users</h2>
    <button @click="getUsers" class="bg-blue-500 text-white p-2 rounded mt-4">Refresh User List</button>
    <div class="p-4 flex flex-wrap gap-4">
      <div v-for="user in users" :key="user" class="p-2 rounded text-left border rounded">
        <h2>
          <b>{{ user.name }}</b>
        </h2>
        <h2>{{ user.wallet }}</h2>
        <p>email: {{ user.email }}</p>
        <p>Role: {{ user.role }}</p>
        <button @click="deleteUser(user.wallet)" class="bg-red-500 text-white p-2 rounded">Delete User</button>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { removeUser, getUsersWallet, getUsersInfo } from '../helpers/ContractFunctions.vue';

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

async function deleteUser(userwallet) {
  const deletedUser = await removeUser(userwallet);
  console.log(deletedUser);
  return;
}
</script>

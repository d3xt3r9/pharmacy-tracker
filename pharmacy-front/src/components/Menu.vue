<template>
  <nav class="bg-sky-900 p-3">
    <div class="flex items-center justify-between">
      <div class="text-white">
        <router-link to="/home">
          <div class="flex items-center mx-20">
            <img src="/src/assets/pharmachainwhite.svg" alt="Logo" class="max-h-8" />
            <h2 class="text-xl font-bold">Pharmacy Supply Chain</h2>
          </div>
        </router-link>
      </div>
      <div class="flex items-center">
        <router-link to="/home" class="text-white font-bold">Actions</router-link>
        <button @click="logout" class="text-white font-bold mx-20">Logout</button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

function logout() {
  router.push('/');
}
</script>

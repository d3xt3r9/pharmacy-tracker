<script>
import { ref } from 'vue';

const userAddress = ref(localStorage.getItem('userAddress') || null);
const isConnected = ref(userAddress.value !== null);

export async function getUserWallet() {
  if (window.ethereum) {
    try {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts',
      });
      // console.log('Connected wallet:', accounts[0]);
      return accounts[0];
    } catch (error) {
      console.error('Error connecting wallet:', error);
      throw error;
    }
  } else {
    alert('MetaMask is not installed. Please install MetaMask and try again.');
  }
}

export async function connectWallet() {
  if (window.ethereum) {
    try {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts',
      });

      userAddress.value = accounts[0];
      localStorage.setItem('userAddress', userAddress.value);
      isConnected.value = true;
      console.log('Connected wallet:', userAddress.value);
      return true;
    } catch (error) {
      console.error('Error connecting wallet:', error);
    }
  } else {
    return false;
  }
}

export { userAddress, isConnected };
</script>

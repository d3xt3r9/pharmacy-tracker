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
    } catch (error) {
      console.error('Error connecting walle t:', error);
      // Optionally, handle specific errors or display user-friendly messages
      throw error; // Propagate error to handle in the calling context if needed
    }
  } else {
    alert('MetaMask is not installed. Please install MetaMask and try again.');
  }
}

export function disconnectWallet() {
  userAddress.value = null;
  localStorage.removeItem('userAddress');
  isConnected.value = false;
}

export { userAddress, isConnected };
</script>

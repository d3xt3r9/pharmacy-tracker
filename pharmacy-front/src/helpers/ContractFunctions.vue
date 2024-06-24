<script>
import { ref, onMounted } from 'vue';
import { ethers } from 'ethers';
import { getUserWallet } from '../helpers/WalletHelper.vue';

const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

const contractABI = [
  'function addParticipant(address _participant, uint8 _role, string _name, string _email)',
  'function addProduct(string _name, uint256 _quantity, uint8 _location) payable',
  'function addProductFee() view returns (uint256)',
  'function getParticipant(address _participant) view returns (string name, string email, address walletAddress, uint8 role)',
  'function getProduct(uint256 _productId) view returns (string name, address currentOwner, uint256 quantity, uint8 location, tuple(address from, address to, uint256 timestamp, string location, uint256 quantity)[] shippingHistory)',
  'function getRole(address _participant) view returns (string)',
  'function getShippingHistory(uint256 _productId) view returns (string[])',
  'function removeParticipant(address _participant)',
  'function productCounter() view returns (uint256)',
  'function products(uint256) view returns (string name, address currentOwner, uint256 quantity, uint8 location)',
  'function roles(address) view returns (uint8)',
  'function updateProduct(uint256 _productId, address _to, uint8 _location, uint256 _quantity) payable',
  'function updateProductFee() view returns (uint256)',
  'function withdraw()',
  'event ParticipantAdded(address indexed participant, uint8 role, string name, string email)',
  'event ParticipantRemoved(address indexed participant)',
  'event ProductAdded(uint256 indexed productId, string name, address indexed owner, uint256 quantity, uint8 location)',
  'event ProductUpdated(uint256 indexed productId, address indexed from, address indexed to, uint8 location, uint256 quantity)',
];

const provider = new ethers.BrowserProvider(window.ethereum);

export async function getUserRole() {
  if (getUserWallet() != null) {
    const signer = await provider.getSigner();
    const signerAddress = await signer.getAddress();
    const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

    try {
      const role = await contractWithSigner.getRole(signerAddress);
      console.log('User role:', role);
      return role;
    } catch (error) {
      console.error('Error getting user role:', error);

      throw error;
    }
  } else {
    alert('Please connect your wallet first.');
  }
}

export async function addUser(wallet, role, name, email) {
  const signer = await provider.getSigner();
  const signerAddress = await signer.getAddress();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

  try {
    const tx = await contractWithSigner.addParticipant(wallet.value, role.value, name.value, email.value, {
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transaction Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function getUsers() {
  const contract = new ethers.Contract(contractAddress, contractABI, provider);

  try {
    // const totalParticipants = await contract.participantCounter();
    const participantsArray = [];
    for (let i = 0; i < 10; i++) {
      const participant = await contract.participants(i);
      participantsArray.push({
        participantAddress: participant.participantAddress,
        role: participant.role,
        name: participant.name,
        email: participant.email,
      });
    }
    return participantsArray;
  } catch (error) {
    console.error('Error fetching participants:', error);
  }
}

export async function addProduct(productName, productQuantity, productLocation) {
  const signer = await provider.getSigner();
  const signerAddress = await signer.getAddress();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  const addProductFee = ethers.parseEther('0.01'); // 0.01 Ether

  try {
    const tx = await contractWithSigner.addProduct(productName.value, productQuantity.value, productLocation.value, {
      value: addProductFee,
      gasLimit: 30000000,
    });
    await tx.wait();
    // console.log('Transaction Hash:', tx.hash);
    return tx.hash;
    // Reset form fields after successful transaction
  } catch (error) {
    console.error('Error:', error);
  }
}

export async function liveproductUpdates() {
  const contract = new ethers.Contract(contractAddress, contractABI, provider);

  contract.on('ProductAdded', (productId, name, owner, quantity, location) => {
    console.log(`Product Added - ID: ${productId}, Name: ${name}, Owner: ${owner}, Quantity: ${quantity}, Location: ${location}`);
  });
}

export { contractAddress, contractABI };
</script>

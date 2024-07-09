<script>
import { ethers } from 'ethers';
import { ErrorDecoder } from 'ethers-decode-error';

import { getUserWallet } from '../helpers/WalletHelper.vue';

const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

const errorDecoder = ErrorDecoder.create();

const contractABI = [
  'function getMyPrsonalInfo() public view returns (address _walletAddress, string memory _name, string memory _email, string memory _role)',
  'function getAddressList() public view  returns (tuple(address)[] addressList)',
  'function getUserlInfo(address _walletAddress) public view returns (string memory _name, string memory _email, string memory _role)',
  'function addUser(address _participant, string _name, string _email, uint8 _role)',
  'function deleteUser(address _user)',
  'function addProduct(uint8 _productId, string _name, uint8 _quantity)',
  'function deleteProduct(uint8 _productId)',
  'function getProductList() public view returns  (tuple(uint8)[] productAddressList)',
  'function getProduct(uint8 _productId) view returns (string name, uint8 quantity, address currentOwner, uint8 currentLocation, tuple(uint256 transferId, address makeTransfer, uint256 timestamp, uint8 location, uint8 quantity)[] shippingHistory)',
  'function getParticipant(address _participant) view returns (string name, string email, address walletAddress, uint8 role)',
  'function addTranfer(uint8 _productId, uint256 _transferId, uint8 _location)',
  // 'function addProductFee() view returns (uint256)',
];

export async function getMyInfo() {
  const provider = new ethers.BrowserProvider(window.ethereum);
  if (getUserWallet() != null) {
    const signer = await provider.getSigner();
    const signerAddress = await signer.getAddress();
    const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

    try {
      const userInfo = await contractWithSigner.getMyPrsonalInfo();
      return userInfo;
    } catch (error) {
      const { reason } = await errorDecoder.decode(error);
      console.log('Revert reason:', reason);
    }
  } else {
    alert('Please connect your wallet first.');
    return null;
  }
}

export async function getUsersWallet() {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  // const signerAddress = await signer.getAddress();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

  try {
    const userAddressList = await contractWithSigner.getAddressList();
    // console.log(userAddressList);
    userAddressList.forEach((user) => {
      // console.log('Wallet Address:', user);
    });
    return userAddressList;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function getUsersInfo(address) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();

  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

  try {
    const userInfo = await contractWithSigner.getUserlInfo(address);
    // console.log('User Info:', userInfo);
    return userInfo;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function createUser(wallet, role, name, email) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  try {
    const tx = await contractWithSigner.addUser(wallet.value, name.value, email.value, role.value, {
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transaction Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function removeUser(wallet) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  try {
    const tx = await contractWithSigner.deleteUser(wallet, {
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transaction Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function addProducToPharmaChain(productId, productName, productQuantity) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const signerAddress = await signer.getAddress();

  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  // const addProductFee = ethers.parseEther('0.01'); // 0.01 Ether

  try {
    const tx = await contractWithSigner.addProduct(productId.value, productName.value, productQuantity.value, {
      // value: addProductFee,
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transactionsss Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function removeProduct(productId) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  try {
    const tx = await contractWithSigner.deleteProduct(productId, {
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transaction Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function getProductbyidFromPharmaChain(productId) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  // const signerAddress = await signer.getAddress();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

  try {
    const productDetails = await contractWithSigner.getProduct(productId);

    // console.log('Product Name:', productDetails.name);
    // console.log('Quantity:', productDetails.quantity);
    // console.log('Current Owner:', productDetails.currentOwner);
    // console.log('Current Location:', productDetails.currentLocation);
    // console.log('Shipping History:');
    // productDetails.shippingHistory.forEach((shippingData) => {
    //   console.log('  Transfer ID:', shippingData.transferId);
    //   console.log('  From:', shippingData.from);
    //   console.log('  To:', shippingData.to);
    //   console.log('  Timestamp:', shippingData.timestamp);
    //   console.log('  Location:', shippingData.location);
    //   console.log('  Quantity:', shippingData.quantity);
    // });
    return productDetails;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function makeTransfer(productID, transferID, locationTransfer) {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);
  try {
    const tx = await contractWithSigner.addTranfer(productID, transferID, locationTransfer, {
      gasLimit: 30000000,
    });
    await tx.wait();
    console.log('Transactionsss Hash:', tx.hash);
    return tx.hash;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}

export async function getProductsId() {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const signer = await provider.getSigner();
  // const signerAddress = await signer.getAddress();
  const contractWithSigner = new ethers.Contract(contractAddress, contractABI, signer);

  try {
    const productsList = await contractWithSigner.getProductList();
    // console.log(userAddressList);
    productsList.forEach((product) => {
      console.log('products id:', product[0]);
    });
    return productsList;
  } catch (error) {
    const { reason } = await errorDecoder.decode(error);
    console.log('Revert reason:', reason);
  }
}
export { contractAddress, contractABI };
</script>

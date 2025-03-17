# Pharmacy Tracker Frontend

A Vue.js frontend application for interacting with a blockchain-based pharmacy and medical supply chain tracking system. This application interfaces with an Ethereum smart contract written in Solidity to provide transparent, secure, and immutable tracking of pharmaceutical products.

## About

This project serves as the user interface for the Pharmacy Supply Chain Tracker, demonstrating the implementation of blockchain technology in the pharmaceutical supply chain. It utilizes ethers.js to enable user interaction with the Solidity smart contract, allowing for verification, tracking, and management of medical supplies from manufacturer to patient.

## Features

- Inventory management on blockchain
- Prescription tracking with immutable records
- Patient record verification
- Supply chain verification and tracking
- Smart contract interaction via ethers.js

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

### Preview Production Build

```sh
npm run preview
```

## Tech Stack

- Vue.js 3
- Vue Router
- ethers.js for Ethereum blockchain interaction
- TailwindCSS for styling

## Integration with Blockchain

This frontend connects to Ethereum smart contracts using ethers.js. To use the application:

1. Ensure you have MetaMask installed in your browser
2. Connect to the appropriate network (local development or test network)
3. Follow the main project README for instructions on deploying the smart contracts

## For More Information

Please refer to the main [project README](../README.md) for complete details on:

- Setting up the Hardhat environment
- Deploying smart contracts
- Security considerations
- License information

## License

This project is licensed under the MIT License with attribution requirements - see the main project README for details.

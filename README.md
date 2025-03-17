# Pharmacy Supply Chain Tracker

A decentralized application for tracking pharmaceutical supply chains using Ethereum blockchain technology. This project demonstrates how blockchain can be used to enhance transparency, security, and traceability in pharmaceutical distribution.

## Project Overview

This application consists of:

- Smart contracts written in Solidity and deployed on Ethereum
- Backend infrastructure managed with Hardhat
- Frontend interface built with Vue.js
- Web3 connectivity via MetaMask and ethers.js

## Prerequisites

- [Node.js](https://nodejs.org/) (v14.x or later recommended)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [MetaMask](https://metamask.io/download/) browser extension installed
- [Hardhat](https://hardhat.org/getting-started/) - Ethereum development environment
- Basic understanding of blockchain concepts and Ethereum

## Installation

1. Clone the repository:

```shell
git clone https://github.com/d3xt3r9/pharmacy-tracker.git
cd pharmacy-tracker
```

2. Install Hardhat:

```shell
# Install Hardhat globally (optional)
npm install -g hardhat

# Or install as a development dependency (recommended)
npm install --save-dev hardhat
```

3. Install dependencies:

```shell
# Install Hardhat dependencies
npm install

# Install Vue.js frontend dependencies
cd pharmacy-front
npm install
cd ..
```

## Running the Blockchain Node

1. Start a local Hardhat node:

```shell
npx hardhat node
```

2. Deploy the smart contracts to the local network (in a new terminal):

```shell
npx hardhat ignition deploy ignition/modules/PharmacyChain.js --network localhost
```

## Running the Frontend

1. Start the Vue.js development server:

```shell
cd frontend
npm run serve
```

2. Open your browser and navigate to `http://localhost:8080`

3. Connect MetaMask to the local Hardhat network (usually `http://localhost:8545`)

## Additional Hardhat Commands

```shell
npx hardhat help
npx hardhat clean
npx hardhat compile
```

## Usage

1. Connect your MetaMask wallet to the application
2. Register as a pharmaceutical entity (manufacturer, distributor, pharmacy, etc.)
3. Create and track pharmaceutical products through the supply chain
4. Verify authenticity and track history of medications

## Security Considerations

**⚠️ IMPORTANT: This is a test/demonstration application only and has not been audited or tested for production use.**

This project is intended for educational and demonstration purposes to showcase blockchain technology in pharmaceutical supply chains. It should not be used in real-world pharmaceutical tracking without significant additional security measures and professional auditing.

Security aspects to consider if developing further:

- **Smart Contract Security**: Contracts would need thorough auditing before production use
- **Private Keys**: Always keep private keys secure and never commit them to repositories
- **Test Networks**: This application is designed for local or test networks, not mainnet deployment
- **Limited Testing**: The security features have not been comprehensively tested
- **No Warranties**: This code is provided "as is" without any guarantees of security or fitness for purpose
- **Educational Purpose**: Use the codebase as a learning tool for blockchain concepts

If adapting this project for real-world use, consult with blockchain security experts and conduct professional audits.

## License

MIT License

Copyright (c) 2024 d3xt3r9

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

**ATTRIBUTION REQUIREMENT**: All copies, modifications, or substantial uses of this software
must include clear and visible attribution to the original author (d3xt3r9) along with the
original repository link (https://github.com/d3xt3r9/pharmacy-tracker). This notice must
appear in any documentation, applications, or derivative works.

The above copyright notice, attribution requirement, and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

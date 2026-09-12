# Smart Contract Test

A Hardhat project containing a mintable token with ERC-20 transfers, ETH-backed minting and burning, and proportional dividend payments.

## Prerequisites

- Node.js 20 or newer
- npm

Hardhat is included as a development dependency.

## Setup

Clone the repository, enter the project directory, and install dependencies:

```bash
git clone <repository-url>
cd <project-directory>
npm install
```

## Compile

```bash
npm run compile
```

## Run Tests

Run the full Hardhat test suite:

```bash
npm run test
```

Run with detailed stack traces:

```bash
npm run test:stack
```

## Deploy Locally

Start a local Hardhat JSON-RPC node in one terminal:

```bash
npx hardhat node
```

In another terminal, deploy the token contract:

```bash
npm run deploy
```

The deployment script prints the deployed contract address.

## Lint and Clean

Run Solidity linting:

```bash
npm run lint
```

Remove generated artifacts and cache files:

```bash
npm run clean
```

## Project Structure

- `contracts/` - Solidity contracts and interfaces
- `scripts/deploy.js` - Deployment script
- `test/` - Hardhat tests
- `hardhat.config.cjs` - Hardhat configuration

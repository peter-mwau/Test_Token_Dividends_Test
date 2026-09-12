# Smart Contract Test

A Hardhat project containing an ERC-20-style token with minting, burning, transfers, and dividend distribution.

## Prerequisites

- Node.js 20 or newer
- npm

Check your Node.js version:

```bash
node --version
```

## Setup

Install the project dependencies from the repository root:

```bash
npm install
```

## Compile

Compile the Solidity contracts with Solidity 0.7.0:

```bash
npm run compile
```

Compiled artifacts are written to `artifacts/`.

## Run Tests

Run the complete test suite:

```bash
npm test
```

To include detailed Hardhat stack traces:

```bash
npm run test:stack
```

## Deploy Locally

Start a local Hardhat JSON-RPC node in one terminal:

```bash
npx hardhat node
```

In a second terminal, deploy the token contract to the local `test` network:

```bash
npm run deploy
```

The deployment script prints the address of the deployed `Token` contract.

## Lint Solidity

If Solhint is available in your environment, run:

```bash
npm run lint
```

## Clean Generated Files

Remove generated build output, artifacts, and the Solidity cache:

```bash
npm run clean
```

## Project Structure

- `contracts/` - Solidity contracts and interfaces
- `scripts/deploy.js` - Local deployment script
- `test/` - Contract tests
- `hardhat.config.cjs` - Hardhat and network configuration

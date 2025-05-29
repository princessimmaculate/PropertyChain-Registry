# PropertyChain Registry

PropertyChain Registry is a blockchain-based real estate ownership system that provides transparent, immutable property records and streamlined ownership transfers on the Stacks blockchain.

## Features

- **Immutable Property Records**: Permanent blockchain-based property registration
- **Transparent Ownership**: Public verification of property ownership
- **Streamlined Transfers**: Automated property transfer processes
- **Document Security**: Cryptographic hashing of legal documents

## Smart Contract Functions

### Property Management
- `register-property`: Register new properties with legal documentation
- `transfer-property`: Execute property ownership transfers
- `get-property-info`: Retrieve property details and legal descriptions
- `get-property-owner`: Check current property owner
- `verify-ownership`: Confirm property ownership status

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to verify contracts
4. Deploy using Clarinet or Stacks CLI

## For Property Registrars

Registrars can register properties by providing:
- Complete property address
- Legal property description
- Document hash for verification
- Transfer fee structure

## For Property Owners

Property owners can transfer ownership through secure blockchain transactions with automatic fee processing.
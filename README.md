# ContainerSSH-STNS-wrapper
a wrapper of authentication server for ContainerSSH to connect to STNS

## Supported versions
- ContainerSSH: 0.5
- STNS: 2.2

## Architecture
1. ContainerSSH queries `/pubkey` endpoint of the wrapper
2. The wrapper queries STNS (`/v1/users?username=<username>`) to get the public key
3. The wrapper returns the authentication response to ContainerSSH
4. If the authentication is successful, ContainerSSH authenticates SSH
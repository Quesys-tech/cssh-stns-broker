# ContainerSSH-STNS-broker

a simple broker for ContainerSSH and STNS

## Supported versions
- [ContainerSSH](https://github.com/ContainerSSH/ContainerSSH): 0.5
- [STNS](https://github.com/STNS/STNS): 2.2

## Architecture
```
       1   +--------------+   2   +------------+   3   +-------------+
    ------>|              |------>|            |------>|             |
User       | ContainerSSH |       |   broker   |       | STNS server |
    <------|              |<----->|            |<------|             |
       6   +--------------+   5   +------------+   4   +-------------+
```
1. User connects to ContainerSSH
2. ContainerSSH queries `/pubkey` endpoint of the broker
3. The broker queries STNS to get the public key
4. STNS returns the public key to the broker
5. The broker returns the authentication response to ContainerSSH
6. If the authentication is successful, ContainerSSH authenticates SSH

## Configuration
### Environment variables
ContainerSSH-STNS-broker can be configured using environment variables. The following environment variables are supported:
- `STNS_URL`: STNS server URL. Default is `http://localhost:1104`.

### ContainerSSH configuration
ContainerSSH shuld be configured to use the broker as an authentication server.
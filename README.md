# vault-init
## Rationale
[Hashicorp Vault](https://www.vaultproject.io/) has a development mode which is memory-only, which does not allow retaining vault data over container restarts. This can make the development flow difficult, especially in situations where the store information is updated or added by different components during multi-step initialization.

This project provides a simple initialization routine for Vault in server mode, returning control over the vault data lifecycle to the developer.

The provided `docker-compose.yml` is an illustrative example for the use of the routine.

## Startup
After vault container startup, if vault data is not present the vault is initialized and `secret` key-value store is created. The vault is also unlocked for use.

The unlock key and root access token are saved in `./vault-data/keys.json`

The root token is saved in `./vault-data/token.txt`

All vault data is saved in `./vault-data/`, thus stopping and even deleting the vault container with `docker-compose down` will not destroy the vault data or change the root key.

## Configuration
Vault configuration is loaded from `./vault-init/config.hcl`

## Environment variables
`VAULT_URL` (default `http://vault:8200/v1`) - vault server URL as seen by the vault-init container

## Reset
To destroy and re-initialize vault, delete the `./vault-data` directory.

## Access to the root key
The root token can be accessed from shell as ``ROOT_TOKEN=`cat /vault-data/token.txt` ...``

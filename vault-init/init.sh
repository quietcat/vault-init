#!/usr/bin/env bash

VAULT_URL_DEFAULT=http://vault:8200/v1
VAULT_URL="${VAULT_URL:-$VAULT_URL_DEFAULT}"

INITIALIZED=$(curl -s $VAULT_URL/sys/init | jq .initialized)
KEYS_FILE="/vault-data/keys.json"

if [ "$INITIALIZED" = "false" ]; then
    echo Initializing vault
    INIT_DATA=$(curl -s --data '{"secret_shares":1,"secret_threshold":1}' $VAULT_URL/sys/init)
    echo -n "$INIT_DATA" > $KEYS_FILE
else
    echo Loading keys
    INIT_DATA=$(cat $KEYS_FILE)
fi

UNSEAL_KEY=$(echo $INIT_DATA | jq -r .keys[0])
ROOT_TOKEN=$(echo $INIT_DATA | jq -r .root_token)

echo Unsealing vault
unseal_data="{\"key\":\"$UNSEAL_KEY\"}"
UNSEAL_RESULT=$(curl -s --data "$unseal_data" $VAULT_URL/sys/unseal)

if [ $INITIALIZED = false ]; then
    echo Create secret store
    auth_header="X-Vault-Token: $ROOT_TOKEN"
    curl --header "$auth_header" --data '{"type":"kv","description":"Secret"}' $VAULT_URL/sys/mounts/secret
fi

echo "Use the following token for authentication: $ROOT_TOKEN"

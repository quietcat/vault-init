#!/bin/bash

API_URL="http://127.0.0.1:8200/v1"

INITIALIZED=$(curl -s $API_URL/sys/init | jq .initialized)
KEYS_FILE="/vault/keys.json"

if [ $INITIALIZED = false ]; then
    echo Initializing vault
    INIT_DATA=$(curl -s --data '{"secret_shares":1,"secret_threshold":1}' $API_URL/sys/init)
    echo -n "$INIT_DATA" > $KEYS_FILE
else
    echo Loading keys
    INIT_DATA=$(cat $KEYS_FILE)
fi

UNSEAL_KEY=$(echo $INIT_DATA | jq -r .keys[0])
ROOT_TOKEN=$(echo $INIT_DATA | jq -r .root_token)

echo Unsealing vault
unseal_data="{\"key\":\"$UNSEAL_KEY\"}"
UNSEAL_RESULT=$(curl -s --data "$unseal_data" $API_URL/sys/unseal)

if [ $INITIALIZED = false ]; then
    echo Create secret store
    auth_header="X-Vault-Token: $ROOT_TOKEN"
    curl --header "$auth_header" --data '{"type":"kv","description":"Secret"}' $API_URL/sys/mounts/secret
fi

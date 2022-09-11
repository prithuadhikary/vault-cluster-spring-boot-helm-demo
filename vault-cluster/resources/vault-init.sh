#The exit code reflects the seal status:
#
#0 - unsealed
#1 - error
#2 - sealed

unset VAULT_STATUS
unset RET_VAL
# Loop till you find vault sealed.
while : ; do
    VAULT_STATUS=$(vault status)
    RET_VAL=$?
    [ $RET_VAL -ne 1 ] && break
    sleep 3s
done

# If sealed, initialize it. Because AWS auto unseal
# is not working, that means it is uninitialized.
if [ $RET_VAL -eq 2 ]; then
    # Means vault is sealed.
    unset INIT_OUTPUT
    INIT_OUTPUT=$(vault operator init)

    # NOTE: You can capture and email the initialization
    # output for rekeying or just to obtain the root token.

    # Extract the root token and do a login with it.
    VAULT_TOKEN=$(echo "$INIT_OUTPUT" | grep 'Initial Root Token' | awk '{ print $4 }')
    export VAULT_TOKEN="$VAULT_TOKEN"
    vault login token="$VAULT_TOKEN"
fi

unset VAULT_STATUS
unset RET_VAL
# Loop till you find vault status not erroring out.
while : ; do
    VAULT_STATUS=$(vault status)
    RET_VAL=$?
    [ $RET_VAL -ne 1 ] && break
    sleep 3s
done

if [ $RET_VAL -eq 0 ]; then
    # Write vault policies (readable from configmap mounted as a volume).
    vault policy write read-secret /vault-policies/read-secret.hcl
    vault policy write create-token /vault-policies/create-token.hcl

    # Create a role read-secret
    vault write auth/token/roles/read-secret allowed_policies=read-secret

    # Check to see if Cert Auth Method is enabled or not.
    ENABLED_AUTH_METHODS=$(vault auth list)
    CERT_METHOD_PATTERN=".*cert.*"

    if [[ ! "$ENABLED_AUTH_METHODS" =~ $CERT_METHOD_PATTERN ]]; then
      vault auth enable cert
    fi

    # Write demo-app certificate
    vault write auth/cert/certs/demo-app display_name=demo-app policies="create-token,read-secret" certificate="@$APP_CERT/tls.crt"

    # Disable v2 secrets engine as it is not compatible to spring-cloud-starter-vault-config
    vault secrets disable secret

    # Enable v1 secrets engine
    vault secrets enable -path=secret -version=1 kv

    # Write something to the demo-app secret.
    vault kv put secret/demo-app message="I am Groot!"
fi
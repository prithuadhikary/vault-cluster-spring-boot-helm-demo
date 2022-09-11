path "secret/*" {
  capabilities = ["read", "list"]
}
path "secret/demo-app*" {
  capabilities = ["read"]
}
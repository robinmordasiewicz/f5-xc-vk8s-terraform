
if [[ "${TF_VAR_tenant}" ]]; then
  read -e -i ${TF_VAR_tenant} -p "Tenant Name: " TF_VAR_tenant
else
  read -e -p "Tenant Name: " TF_VAR_tenant
fi
export TF_VAR_tenant

export TF_VAR_VOLT_API_P12_FILE="${TF_VAR_tenant}.console.ves.volterra.io.api-creds.p12"
export VOLT_API_P12_FILE="${TF_VAR_tenant}.console.ves.volterra.io.api-creds.p12"
echo "server-urls: https://${TF_VAR_tenant}.console.ves.volterra.io/api" > .vesconfig
echo "p12-bundle: ${TF_VAR_tenant}.console.ves.volterra.io.api-creds.p12" >> .vesconfig

if [[ -f "$TF_VAR_VOLT_API_P12_FILE" ]]; then
  read -e -s -p "Enter cert passphrase: " TF_VAR_VES_P12_PASSWORD
  echo "Enter cert passphrase: ***********"
  export TF_VAR_VES_P12_PASSWORD
  export VES_P12_PASSWORD=${TF_VAR_VES_P12_PASSWORD}
  if [[ "${TF_VAR_VES_P12_PASSWORD}" ]]; then
    if [[ "${TF_VAR_namespace}" ]]; then
      read -e -i ${TF_VAR_namespace} -p "Namespace: " TF_VAR_namespace
    else
      read -e -p "Namespace: " TF_VAR_namespace
    fi
    export TF_VAR_namespace
    export namespace="${TF_VAR_namespace}"
    if [[ "${TF_VAR_fqdn}" ]]; then
      read -e -i ${TF_VAR_fqdn} -p "Domain Name: " TF_VAR_fqdn
    else
      read -e -p "Domain Name: " TF_VAR_fqdn
    fi
    export TF_VAR_fqdn
    export fqdn="${TF_VAR_fqdn}"
  fi
else
  echo "${VOLT_API_P12_FILE} file not found"
fi

echo "terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64"
echo "terraform init"
echo "terraform plan"
echo "terraform apply"
echo "vesctl --config .vesconfig configuration get namespace ${TF_VAR_namespace}"
echo "vesctl --config .vesconfig configuration get healthcheck -n ${TF_VAR_namespace}"
echo "vesctl --config .vesconfig configuration get healthcheck http-healthcheck -n ${TF_VAR_namespace}"
echo "vesctl --config .vesconfig configuration get http_loadbalancer -n ${TF_VAR_namespace}"
echo "vesctl --config .vesconfig configuration get http_loadbalancer http-lb -n ${TF_VAR_namespace}"

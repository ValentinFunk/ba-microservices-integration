# Gets the Service's external IPs are available and updates the configMap with these as endpoints
KUBE_NAMESPACE=${KUBE_NAMESPACE:-default}

get_loadbalancer_ip () {
  SERVICENAME=$1
  echo $(kubectl get svc $SERVICENAME --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
}

USERS_SERVICE_ENDPOINT="http://$(get_loadbalancer_ip users-service)"
WEB_SERVICE_ENDPOINT="http://$(get_loadbalancer_ip web-service)"
PRODUCTS_SERVICE_ENDPOINT="http://$(get_loadbalancer_ip products-service)"

# Update Endpoints
echo "{}" > .tmp.json
jinja2 --strict -D userServiceEndpoint=$USERS_SERVICE_ENDPOINT -D productsServiceEndpoint=$PRODUCTS_SERVICE_ENDPOINT templates/web-service/configmap-endpoints.yaml .tmp.json | kubectl apply --namespace=$KUBE_NAMESPACE -f -
rm .tmp.json
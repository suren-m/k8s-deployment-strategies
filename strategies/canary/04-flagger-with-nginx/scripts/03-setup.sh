#!/bin/bash
printf "\n..Setup - Initial Stable Deployment..\n"

instance_count=$1
namespace=$2

# accept parameter for number of instances (default 5)
if [[ -z "$1" ]]; # or [ $# -eq 0 ]
  then        
    read -p "Required Number of Instances (default is 5): "
    instance_count=${REPLY:-5}
fi

if [[ -z "$2" ]]; 
  then        
    read -p "Target Namespace (default is canary-flagger) : "
    namespace=${REPLY:-"canary-flagger"}
fi

# deploy manifests
printf "\n...creating deployment for deployment.yaml\n"
kubectl apply -f ../manifests/deployment.yaml -n $namespace

printf "\n...scaling deployment to $instance_count\n"
kubectl scale --replicas=$instance_count deployment/myapp -n $namespace

printf "\n...creating deployment for deployment.yaml\n"
kubectl apply -f ../manifests/hpa.yaml -n $namespace

printf "\n...setting up ingress resource\n"
kubectl apply -f ../manifests/ingress.yaml -n $namespace

printf "\n...complete\n"


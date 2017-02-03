# README

This repository collect and apply kubernetes configuration files for jenkins-infra.

A makefile is provided to execute common tasks.

```
* make init         Create secrets configuration files
* make apply        Apply Kubernetes configurations 
* make test         Run some tests
* make clean        Remove secrets conriguration files
* make status       Print all pods on kubernetes cluster
```

## Requirements

### Kubectl

In order to apply kubernetes files, you gonna need 
'kubectl' installed and correctly configured
You can use one of the following procedure to configure it.

##### 1. Azure-cli 
```make get_kubectl_config``` can be use to configure your 
configuration file following 2 conditions:
* azure-cli 2 is installed and configured
* ssh access to kubernetes with user azureuser and ssh key ~/.ssh/id_rsa

##### 2. Ssh
If ```make get_kubectl_config``` doesn't work, you can still use following command
scp name.location.cloudapp.azure.com:~/.kube/config .kube/config.test where 
name and location need to be adapated

#### File: .env
File '.env' contain 'key=value' which define variables used by 
Makefile, scripts,...

template/env is an exemple that can be use to create your .env file

```cp template/env .env```
```edit .env```

N.B: 
* Some variables can have default value define by third tools like azure-cli 2
  Cfr comments for each variables.

## Resources

This project can orchestrate two kubernetes configuration type
1. Daemonset:
DaemonSet ensures that all (or some) nodes run a copy of a pod. As nodes are added to the cluster, pods are added to them. As nodes are removed from the cluster, those pods are garbage collected
2. Secrets
secret are intended to hold sensitive information, such as passwords, OAuth tokens, and ssh keys

More will come in futur.

#### Daemonset

In order to create new deamonsets, you have to add your kubernetes configuration files
to config/daemonsets

#### Secret

In order to create new secrets, you have to create following resources
1. Add a bash script to generate secret config
   
   ```touch scripts/secrets/your_new_secrets.sh```
2. Update Documentation if some variables need to be defined in .env| templates/env
3. Apply all secrets
   ```make apply_secrets```

## Testing

BATS need to be installed in order to run tests
```make test```


#README[DRAFT]

This repository is used to contain kubernetes configuration files.

We use one directory per configuration type.

For security reasons we don't share the directory 'secrets' but only secrets-template

## Init kubectl configuration from azure containers created by (jenkins-infra)[https://github.com/jenkins-infra/azure]

```az acs kubernetes get-credentials --dns-prefix ${PREFIX}mgmt --location=eastus```

##Deploy Datadog agent 
This procedure describe how to deploy one datadog per kubernetes host (master/slaves)

1. Create secret configuration file (!this secret should be commit)
```cp secret-templates/datadog.yml to secret/datadog.yml```
2. replace [base64 encoded apiKey] by $(echo -n 'apikey' | base64)
3. Deploy apiKey secret on kubernetes
    kubectl create -f secret/datadog.yml
4. Check datadog secret exist
```kubectl get secrets datadog -o yaml```
5. Deploy datadog daemon_set 
```kubectl create -f daemonsets/datadog.yml```
6. Check datadog daemonset exist
```kubectl get daemonset dd-agent -o yaml```

##Deploy fluentd agent
This procedure describe how to deploy one fluentd per kubernetes host (master/slave)
1. Create secret configuration file (!this secret should be commit)
```cp secret-templates/azure-secret.yaml to secret/azure-secret.yaml```
2. Update secret/azure-secret.yaml with correct secret value
3. Deploy apiKey secret on kubernetes
    kubectl create -f secret/azure-secret.yml
4. Check if azure-secret secret exist
```kubectl get secrets azure-secret -o yaml```
5. Deploy azure-secret daemon_set 
```kubectl create -f daemonsets/azure-secret.yml```
6. Check azure-secret daemonset exist
```kubectl get daemonset dd-agent -o yaml```

##Howto to add new applications
###Create k8s new applications file
```
kubectl create -f secrets/app.yaml
kubectl create -f daemonsets/app.yaml
```

###Apply modifications
```
kubectl apply -f secrets/app.yaml
kubectl apply -f daemonsets/app.yaml
```

###Encode Secrets
All secrets must be encoded in base64 before being used in configuration file.
For that use the following example

####Encode:
```
echo -n 'your secret' | base64
```

####Decode secret:
```
echo 'base64 secret' | base64 -d
```

###Get kubectl configuration from azure
Following command is based on (jenkins-infra)[https://github.com/jenkins-infra/azure]
Just modify ${PREFIX} to your need
```
az acs kubernetes get-credentials --dns-prefix "${PREFIX}mgmt" --location=$LOCATION
```

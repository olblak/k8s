#README[DRAFT]

This repository is used to contain kubernetes configuration files.

We use one directory per configuration type.

For security reasons we don't share the directory 'secrets' but only secrets-template

##Howto
###Create k8s new applications
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
```
az acs kubernetes get-credentials --dns-prefix "${PREFIX}mgmt" --location=$LOCATION
```

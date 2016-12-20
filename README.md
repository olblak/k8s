#README

This repository is used to contain kubernetes configuration files.
We use one directory per configuration type.

__For security reasons we don't share 'secrets' but only secrets-template__

##Howto
###Create new applications
```
kubectl create -f secrets/app.yaml
kubectl create -f daemonsets/app.yaml
```

###Apply modifications
```
kubectl apply -f secrets/app.yaml
kubectl apply -f daemonsets/app.yaml
```

##Secrets
All secrets must be encoded in base64.
For that use the following example

Encode:
```
echo -n 'your secret' | base64
```

Decode secret:
```
echo 'base64 secret' | base64 -d
```

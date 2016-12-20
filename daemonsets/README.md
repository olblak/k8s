#Howto
##Deploy datadog agent 
Require a datadog apiKey
```
kubectl create -f secrets/datadog.yaml
kubectl create -f daemonsets/dd-agent.yaml
```

#Documentation
[Documentation](http://kubernetes.io/docs/admin/daemons/)

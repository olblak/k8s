# README

This repository collect and apply kubernetes configuration files for jenkins-infra.

A makefile is provided to execute following common tasks.

```
* make init         # Create kubectl configuration with ssh and create secrets configuration files
* make apply        # Apply Kubernetes configurations 
* make clean        # Remove secrets conriguration files
* make status       # Print all pods on kubernetes cluster
```
There are two ways to use this project.

1. Deploy existing environment
2. Create/Update an existing environment.

## Deploy existing environment

! Require an existing azure environment

* Add in k8s.cfg 

    ```VAULT_PASSWORD=<password to decrypt ./configurations/$ENV/**/.gpg>```

* If necessary override key/value defined in k8s.default into k8s.cfg

__! You will deploy on cluster ${PREFIX}mgmt.${LOCATION}.cloudapp.azure.com__
__! Require ssh access to azureuser@${PREFIX}mgmt.${LOCATION}.cloudapp.azure.com__

Once done, execute following commands

```
    make init   # Create kubectl configuration with ssh and create secrets configuration files
    make apply  # Apply kubernetes configurations
    make clean  # Delete unencrypted secret files
```

## Create/Update an environment

! Require an existing azure environment

* Add in k8s.cfg

    ```VAULT_PASSWORD=<password to [de|enc]crypt ./configurations/$ENV/**/.gpg>```
* If necessary override key/value defined in k8s.default into k8s.cfg
* Add all key/value needed to generate secrets
  They are explained in table2.Secrets from doc/README.adoc
  If azure-cli is correctly configured you only need to add
  ```
    STORAGE_ACCOUNT_LOGS_KEY=value
    DATADOG_API_KEY=value
  ```

__! You will deploy on cluster ${PREFIX}mgmt.${LOCATION}.cloudapp.azure.com__
__! Require ssh access to azureuser@${PREFIX}mgmt.${LOCATION}.cloudapp.azure.com__

Once done, execute following commands

```
    make generate/secrets # Browse scripts in scripts/secrets_generator/ to create secrets
    make init   # Decrypt secret files
    make apply  # Apply kubernetes configurations
    make clean  # Delete unencrypted secret files
```

__More documentations can be found in doc directory [doc](doc/README.adoc)__

## Concernes

Even if Kubernetes is a great tool, it also have missing features that must be knowned  
and some workarounds founded   
Keep in mind that those missing features may be implemented in a near futur but we need solutions for today. 

### Kubernetes Resources

#### Secrets
When we update secret, for example with: 
```kubectl apply -f secret.yaml```  
Kubernetes doesn't reload resources that use this secret  
Which means that we cannot only update secrets but we also have to take care of each resources that consume this secret resource  
! Secret doesn't keep a list of resources that use it.  
    
Suggestions:

1. As suggested by kubernetes community, we can change secret's resources name, each time we apply a modification 
   Ex.: secret become secret-1  
   Reasons why I do not like this solution are: 

    * Each time we update a secret, we have to update all secret's name referenced to this secret within all resources.
      which can be quite cumbersomed and error prone.
    * It become hard to define generic resources accross environments that use specific secrets  
      Ex.: In dev, deployment.yaml linked to secret.yml become deployment-1.yaml linked to secret-6.yaml
      because we modified 6 times secrets.yaml
      and in production we should have deployment-1.yaml linked to secret-4.yaml
      because only modified it 4 times
    * It only work for deployments so anyways we have to manage daemonset differently

2. A workaround would be to add a tag to each resources that use this secret 
  secret-<secret_name>: linked
  Each time we update a secret resource, we search for all pods with label secret-<secret_name> = linked
  And we recreate them.  
  Which is the solution implemented in scripts right now but it introduce down time
3. We need to find a way to do safe rolling update, at the moment we only delete/create pods

#### ConfigMap

Same problem than secrets, pods that use configmap values, are not reloaded by a configmap change
https://github.com/kubernetes/kubernetes/pull/31701


#### Daemonset

Daemonset changed, doesn't 'reload' pods created by daemonset  
If daemonset changed, we have to delete all pods associated to it, new pods will immediately be created by the new daemonset configuration.   
-> https://github.com/kubernetes/kubernetes/issues/22368  
We need to find a way to do safe rolling update  

### General:

If we want to automate resources deployments, we also need to 'publish' secrets on git repository.   
Obviously those secrets must be encrypted.   

Suggestions:
* We can use either password either certificates for that  
  Right now I am using a password in VAULT_PASSWORD variables  
  This password must be convigured into jenkins in order to deploy it through jenkins.  
  Do we want to use different password per environment?   
  Should we be able to deploy all environments from one Jenkins instance?

* Another solutions would be to use git submodules to git pull from private repository

We can combine both solutions as well

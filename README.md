# README

This repository collect and apply kubernetes configuration files for jenkins-infra.

A makefile is provided to execute following common tasks.

```
* make init         Create secrets configuration files
* make apply        Apply Kubernetes configurations 
* make clean        Remove secrets conriguration files
* make status       Print all pods on kubernetes cluster
```
There are two ways to use this project.

1. Deploy existing environment
2. Create/Update an existing environment.

## Deploy existing environment

! Require an existing azure environment

* Add in k8s.cfg 

    ```VAULT_PASSWORD=<password to decrypt ./configurations/$ENV/**/.gpg>```

* If necessary override key/value defined in k8s.default into k8s.cfg

Once good, execute following commands

```
    make init   # Decrypt secret files
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

Once good, execute following commands

```
    make generate/secrets # Browse scripts in scripts/secrets_generator/ to create secrets
    make init   # Decrypt secret files
    make apply  # Apply kubernetes configurations
    make clean  # Delete unencrypted secret files
```

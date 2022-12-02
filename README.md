# KeyCloak Container

Deploy keycloak in a pod (with postgres) on podman

## Usage

Replace `MY_DB_PASSWORD` and `MY_KEYCLOAK_PASSWORD` below with your respective passwords 

```bash
mkdir $HOME/postgres-keycloak-data
./deploy.sh MY_DB_PASSWORD MY_KEYCLOAK_PASSWORD
```
Navigate browser to https://localhost:8443  

Login with user `admin`, password used above in place of `MY_KEYCLOAK_PASSWORD`

# Minimal postfix docker image

Simple postfix host intended for container clusters like swarm, Kubernetes, k3s, etc

This image allows you to run a postfix server (**plain SMTP only**) internally inside your docker cluster installation to centralise outgoing email sending.

This image is not for a production environment since there is no way to configure TLS, authentication, relay, etc.

## How to run

```bash
docker run --rm --name postfix -e "MY_NETWORKS=192.168.0.0/24" -p 25:25 dcarrillo/postfix:latest
```

## Runtime configuration as environment vars

```bash
MY_HOSTNAME=The internet hostname of this mail system
MY_DOMAIN=The internet domain name of this mail system
MY_NETWORKS=The list of "trusted" remote SMTP clients, probably the CIDR for your internal network inside your cluster
MY_ROOT_ALIAS=Alias of the root user to add to the aliases database
```

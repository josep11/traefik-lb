# Traefik LoadBalancer #

This project sets up a Traefik load balancer in order to serve other projects through it.

* Load balancer: `https://traefik.josep.co`

Run: `make` to see available `Makefile` targets.

```bash
Available targets:

  docker/restart                      Restart base stack resources
  docker/start                        Start base stack resources
  docker/stop                         Stop base stack resources
  ...
  start                               Start base stack resources. Alias for: docker/start
  stop                                Stop base stack resources. Alias for: docker/stop

```

## Before start ##

### Generate SSL certificates ###

```shell
make ssl/josep
```

### Hosts file ###

You need to add an entry for the Traefik home page and then as many entries as projects that you have, each with its own subdomain. Like in the second line.

```bash
127.0.0.1 traefik.josep.co
127.0.0.1 myproject.josep.co
```

## Run ##

```shell
make start
```

## Configure other projects to be served through the load balancer ##

Having a project with name: `my-flask-app` that is served through port 5000.

### Add it to the hosts file ###

```bash
127.0.0.1 traefik.josep.co
127.0.0.1 my-flask-app.josep.co
```

### Add Traefik Labels from other projects ###

```yml
version: "3.9"
services:
  web:
    build: .
    env_file:
      - .env
    ports:
      - "6000:5000"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-flask-app.entrypoints=websecure"
      - "traefik.http.routers.my-flask-app.tls=true"
      - "traefik.http.routers.my-flask-app.rule=Host(`my-flask-app.josep.co`)"
      - "traefik.http.routers.my-flask-app.service=my-flask-app"
      - "traefik.http.services.my-flask-app.loadbalancer.server.port=5000"
```

Now you can access [https://my-flask-app.josep.co](https://my-flask-app.josep.co)

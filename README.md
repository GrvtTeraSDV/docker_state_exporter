
# Notice

Repo forked from karugaru/docker_state_exporter. This repo is not maintain.
Original repo : 
 - https://github.com/karugaru/docker_state_exporter

# Docker State Exporter

Exporter for docker container state

Prometheus exporter for docker container state, written in Go.

One of the best known exporters of docker container information is [cAdvisor](https://github.com/google/cadvisor).\
However, cAdvisor does not export the state of the container.

This exporter will only export the container status and the restarts count.

This fork change the value of the metric "container_state_status" and you have a code for each status : 
 - 6 for running
 - 5 for restarting
 - 4 for created
 - 3 for paused
 - 2 for dead
 - 1 for exited
 - 0 for removing

So you can now use it on a stat panel with thresholds color scheme.

## Installation and Usage

The `docker_state_exporter` listens on HTTP port 8080 by default.

### Docker

For Docker run.

```bash
sudo docker run -d \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -p 8080:8080 \
  ghcr.io/grvtterasdv/docker_state_exporter:latest \
  -listen-address=:8080
```

For Docker compose.

```yaml
---

services:
  docker_state_exporter:
    image: ghcr.io/grvtterasdv/docker_state_exporter:latest
    container_name: docker_state_exporter
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /var/run/docker.sock
    ports:
      - "8080:8080"
```

## Metrics

This exporter will export the following metrics.

- container_state_health_status
- container_state_status
- container_state_oomkilled
- container_state_startedat
- container_state_finishedat
- container_restartcount

These metrics will be the same as the results of docker inspect.

This exporter also exports the standard
[Go Collector](https://pkg.go.dev/github.com/prometheus/client_golang/prometheus#NewGoCollector)
and [Process Collector](https://pkg.go.dev/github.com/prometheus/client_golang/prometheus#NewProcessCollector).

## Caution

This exporter will do a docker inspect every time prometheus pulls.\
If a large number of requests are made, there will be performance issues. (I think. Not verified.)\
So, this app caches the result of docker inspect for 1 second.
So, please note that if you set the scrape_interval of prometheus to less than one second, you may get the same result back.

## Development building and running

I am running this application on Docker (linux/amd64).
I have not tested it in any other environment.

### Build

```bash
git clone https://github.com/GrvtTeraSDV/docker_state_exporter.git
cd docker_state_exporter
sudo docker build -t docker_state_exporter_test .
```

### Run

```bash
sudo docker run -d \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -p 8080:8080 \
  docker_state_exporter_test \
  -listen-address=:8080
```

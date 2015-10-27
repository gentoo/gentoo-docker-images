# HOW TO:

Since the `build.sh` file is being shared across all amd64 Dockerfiles,
to build the docker container:

###### NOTE: Stay in the current directory so that you have the `build.sh` script in the context

- amd64: `docker build -f amd64/Dockerfile .`
- amd64-hardened: `docker build -f amd64-hardened/Dockerfile .`
- amd64-hardened-nomultilib: `docker build -f amd64-hardened-nomultilib/Dockerfile .`
- amd64-nomultilib: `docker build -f amd64-nomultilib/Dockerfile .`

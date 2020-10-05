# Hertz Lattice

 [![Docker Automated build](https://img.shields.io/docker/automated/utensils/hertz-lattice.svg)](https://hub.docker.com/r/utensils/hertz-lattice/) [![Docker Pulls](https://img.shields.io/docker/pulls/utensils/hertz-lattice.svg)](https://hub.docker.com/r/utensils/hertz-lattice/) [![Docker Stars](https://img.shields.io/docker/stars/utensils/hertz-lattice.svg)](https://hub.docker.com/r/utensils/hertz-lattice/) [![](https://images.microbadger.com/badges/image/utensils/hertz-lattice.svg)](https://microbadger.com/images/utensils/hertz-lattice "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/utensils/hertz-lattice.svg)](https://microbadger.com/images/utensils/hertz-lattice "Get your own version badge on microbadger.com")  


## About

GNU Radio & Friends in a Docker image. **This image does not do much yet...**

## TODO
Build gr-gsm using the maint-fork mentioned in this github [issue](https://github.com/ptrkrysik/gr-gsm/issues/475)

## Building

To build the project:
```shell
make
```

To list the images:
```shell
make list
```

To run any tests:
```shell
make test
```

To push image to remote docker repository:
```shell
REPO_PASSWORD='MyPassword!$' make push
```

To update README on remote docker repository (docker hub):

```shell
REPO_PASSWORD='MyPassword!$' make push-readme
```

To cleanup and remove built images:
```shell
make clean
```

## Usage

To run the container:
```shell
docker run -i -t utensils/hertz-lattice
```


## Environment Variables


| Variable | Default Value   | Description |
| -------- | --------------- | ----------- |
| `ENV`    | `DEFAULT_VALUE` | Description |


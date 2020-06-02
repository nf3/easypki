module github.com/borud/easypki

go 1.13

require (
	github.com/boltdb/bolt v1.3.1
	github.com/go-yaml/yaml v2.1.0+incompatible
	github.com/google/easypki v1.1.0
	github.com/urfave/cli v1.22.2
)

replace github.com/google/easypki => ./

replace github.com/google/easypki/pkg/store => ./pkg/store

replace github.com/google/easypki/pkg/easkypki => ./pkg/easkypki

replace github.com/google/easypki/pkg/certificate => ./pkg/certificate

// Package sha512 contains the "k6/x/it/sha512" k6 integration test extension.
package sha512

import (
	"crypto/sha512"
	"encoding/hex"

	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/sha512", new(module))
}

type module struct{}

func (*module) Sum(data []byte) string {
	sum := sha512.Sum512(data)

	return hex.EncodeToString(sum[:])
}

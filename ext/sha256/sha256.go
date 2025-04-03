// Package sha256 contains the "k6/x/it/sha256" k6 integration test extension.
package sha256

import (
	"crypto/sha256"
	"encoding/hex"

	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/sha256", new(module))
}

type module struct{}

func (*module) Sum(data []byte) string {
	sum := sha256.Sum256(data)

	return hex.EncodeToString(sum[:])
}

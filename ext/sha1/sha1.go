// Package sha1 contains the "k6/x/it/sha1" k6 integration test extension.
package sha1

import (
	"crypto/sha1" // #nosec G505
	"encoding/hex"

	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/sha1", new(module))
}

type module struct{}

func (*module) Sum(data []byte) string {
	sum := sha1.Sum(data) // #nosec G401

	return hex.EncodeToString(sum[:])
}

// Package crc32 contains the "k6/x/it/crc32" k6 integration test extension.
package crc32

import (
	"hash/crc32"

	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/crc32", new(module))
}

type module struct{}

func (*module) Checksum(data []byte) uint32 {
	return crc32.ChecksumIEEE(data)
}

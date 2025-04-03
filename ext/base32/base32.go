// Package base32 contains the "k6/x/it/base32" k6 integration test extension.
package base32

import (
	"encoding/base32"

	"github.com/grafana/sobek"
	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/base32", new(module))
}

type module struct{}

func (*module) Encode(data []byte) string {
	return base32.StdEncoding.EncodeToString(data)
}

func (*module) Decode(str string, runtime *sobek.Runtime) (sobek.ArrayBuffer, error) {
	data, err := base32.StdEncoding.DecodeString(str)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return runtime.NewArrayBuffer(data), nil
}

// Package ascii85 contains the "k6/x/it/ascii85" k6 integration test extension.
package ascii85

import (
	"encoding/ascii85"

	"github.com/grafana/sobek"
	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/ascii85", new(module))
}

type module struct{}

func (*module) Encode(data []byte) string {
	dst := make([]byte, ascii85.MaxEncodedLen(len(data)))
	n := ascii85.Encode(dst, data)

	return string(dst[:n])
}

func (*module) Decode(str string, runtime *sobek.Runtime) (sobek.ArrayBuffer, error) {
	dst := make([]byte, len(str))

	n, _, err := ascii85.Decode(dst, []byte(str), true)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return runtime.NewArrayBuffer(dst[:n]), nil
}

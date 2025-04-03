// Package base64_as_base32 contains "k6/x/it/base64" module but registered as "k6/x/it/base32".
package base64_as_base32

import (
	"encoding/base64"

	"github.com/grafana/sobek"
	"go.k6.io/k6/js/modules"
)

func init() {
	modules.Register("k6/x/it/base32", new(module))
}

type module struct{}

func (*module) Encode(data []byte) string {
	return base64.StdEncoding.EncodeToString(data)
}

func (*module) Decode(str string, runtime *sobek.Runtime) (sobek.ArrayBuffer, error) {
	data, err := base64.StdEncoding.DecodeString(str)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return runtime.NewArrayBuffer(data), nil
}

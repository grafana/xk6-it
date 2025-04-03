// Package it contains the "k6/x/it" k6 integration test helper extension.
package it

import (
	"crypto/sha256"
	"crypto/sha512"
	"encoding/ascii85"
	"encoding/base32"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"hash/crc32"
	"io"
	"reflect"

	"github.com/grafana/sobek"
	"go.k6.io/k6/js/modules"
	"go.k6.io/k6/metrics"
	"go.k6.io/k6/output"
)

func init() { //nolint:gochecknoinits
	modules.Register("k6/x/it", new(rootModule))
	output.RegisterExtension("it", newOutput)
}

type rootModule struct{}

func (*rootModule) NewModuleInstance(vu modules.VU) modules.Instance {
	return &module{vu}
}

type module struct {
	vu modules.VU
}

func (m *module) Exports() modules.Exports {
	return modules.Exports{
		Named: map[string]any{
			"equal":         m.equal,
			"base32encode":  m.base32encode,
			"base32decode":  m.base32decode,
			"base64encode":  m.base64encode,
			"base64decode":  m.base64decode,
			"ascii85encode": m.ascii85encode,
			"ascii85decode": m.ascii85decode,
			"crc32":         m.crc32,
			"sha256sum":     m.sha256sum,
			"sha512sum":     m.sha512sum,
		},
	}
}

func (m *module) equal(x, y any) bool {
	return reflect.DeepEqual(x, y)
}

func (m *module) base32encode(data []byte) string {
	return base32.StdEncoding.EncodeToString(data)
}

func (m *module) base32decode(str string) (sobek.ArrayBuffer, error) {
	data, err := base32.StdEncoding.DecodeString(str)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return m.vu.Runtime().NewArrayBuffer(data), nil
}

func (m *module) base64encode(data []byte) string {
	return base64.StdEncoding.EncodeToString(data)
}

func (m *module) base64decode(str string) (sobek.ArrayBuffer, error) {
	data, err := base64.StdEncoding.DecodeString(str)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return m.vu.Runtime().NewArrayBuffer(data), nil
}

func (*module) ascii85encode(data []byte) string {
	dst := make([]byte, ascii85.MaxEncodedLen(len(data)))
	n := ascii85.Encode(dst, data)

	return string(dst[:n])
}

func (m *module) ascii85decode(str string) (sobek.ArrayBuffer, error) {
	dst := make([]byte, len(str))

	n, _, err := ascii85.Decode(dst, []byte(str), true)
	if err != nil {
		return sobek.ArrayBuffer{}, err
	}

	return m.vu.Runtime().NewArrayBuffer(dst[:n]), nil
}

func (*module) crc32(data []byte) uint32 {
	return crc32.ChecksumIEEE(data)
}

func (m *module) sha256sum(data []byte) string {
	sum := sha256.Sum256(data)

	return hex.EncodeToString(sum[:])
}

func (m *module) sha512sum(data []byte) string {
	sum := sha512.Sum512(data)

	return hex.EncodeToString(sum[:])
}

var (
	_ modules.Module   = (*rootModule)(nil)
	_ modules.Instance = (*module)(nil)
)

type out struct {
	names  map[string]struct{}
	writer io.Writer
}

func newOutput(params output.Params) (output.Output, error) {
	return &out{names: make(map[string]struct{}), writer: params.StdErr}, nil
}

func (o *out) Description() string {
	return "it"
}

func (o *out) Start() error {
	return nil
}

func (o *out) AddMetricSamples(containers []metrics.SampleContainer) {
	for _, container := range containers {
		for _, sample := range container.GetSamples() {
			name := sample.Metric.Name

			if _, found := o.names[name]; !found {
				o.names[name] = struct{}{}
			}
		}
	}
}

func (o *out) Stop() error {
	names := make([]string, 0, len(o.names))

	for name := range o.names {
		names = append(names, name)
	}

	return json.NewEncoder(o.writer).Encode(names)
}

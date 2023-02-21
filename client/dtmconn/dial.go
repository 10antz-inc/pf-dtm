package dtmconn

import (
	"crypto/tls"
	"crypto/x509"
	"os"
	"strings"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/credentials/insecure"
)

var (
	insecureMode bool
	transCreds   grpc.DialOption
)

func init() {
	insecureMode = strings.TrimSpace(os.Getenv("GRPC_INSECURE")) == "true"
	if insecureMode {
		transCreds = grpc.WithTransportCredentials(insecure.NewCredentials())
		return
	}

	sysCertPool, err := x509.SystemCertPool()
	if err != nil {
		panic(err)
	}

	transCreds = grpc.WithTransportCredentials(credentials.NewTLS(&tls.Config{RootCAs: sysCertPool}))
}

func Dial(addr string, opts ...grpc.DialOption) (*grpc.ClientConn, error) {
	return grpc.Dial(addr, DialOptions(addr, opts...)...)
}

func DialOptions(addr string, opts ...grpc.DialOption) []grpc.DialOption {
	if insecureMode {
		opts = append(opts, transCreds)
		return opts
	}

	opts = append(opts, grpc.WithAuthority(addr))
	return opts
}

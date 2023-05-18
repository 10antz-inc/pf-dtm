# Fork 元との差分、及び、意図

## gRPC で https が使えない

Dial 時のオプションが http ( HTTP/1.1 ) 用に固定されているため https ( HTTP/2 ) を始めとする TLS 通信だと利用できない


[元コードの該当箇所 ( 23.05.18 時点 )](https://github.com/dtm-labs/dtm/blob/90160a8/client/dtmgrpc/dtmgimp/grpc_clients.go#LL63C3-L64C109)

```go
inOpt := grpc.WithChainUnaryInterceptor(interceptors...)
conn, rerr := grpc.Dial(grpcServer, inOpt, grpc.WithTransportCredentials(insecure.NewCredentials()), opts)
```

そのため、[dtmconn パッケージに Dial 関数を実装](client/dtmconn/dial.go)した内部的には環境変数 `GRPC_INSECURE` で切り替えられるようにした上で、以下のように修正した

```go
inOpt := grpc.WithChainUnaryInterceptor(interceptors...)
conn, rerr := dtmconn.Dial(grpcServer, inOpt, opts)
```

なお、セキュリティ上、デフォルトは https としている

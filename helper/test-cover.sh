set -x
export DTM_DEBUG=1
echo "mode: count" > coverage.txt
for store in redis boltdb mysql postgres; do
  TEST_STORE=$store go test -failfast -covermode count -coverprofile=profile.out -coverpkg=github.com/10antz-inc/pf-dtm/client/dtmcli,github.com/10antz-inc/pf-dtm/client/dtmcli/dtmimp,github.com/dtm-labs/logger,github.com/10antz-inc/pf-dtm/client/dtmgrpc,github.com/10antz-inc/pf-dtm/client/workflow,github.com/10antz-inc/pf-dtm/client/dtmgrpc/dtmgimp,github.com/10antz-inc/pf-dtm/dtmsvr,dtmsvr/config,github.com/10antz-inc/pf-dtm/dtmsvr/storage,github.com/10antz-inc/pf-dtm/dtmsvr/storage/boltdb,github.com/10antz-inc/pf-dtm/dtmsvr/storage/redis,github.com/10antz-inc/pf-dtm/dtmsvr/storage/registry,github.com/10antz-inc/pf-dtm/dtmsvr/storage/sql,github.com/10antz-inc/pf-dtm/dtmutil -gcflags=-l ./... || exit 1
    echo "TEST_STORE=$store finished"
    if [ -f profile.out ]; then
        cat profile.out | grep -v 'mode:' >> coverage.txt
        echo > profile.out
    fi
done

# go tool cover -html=coverage.txt

# curl -s https://codecov.io/bash | bash

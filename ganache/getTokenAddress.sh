TXHASH=$1
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TXHASH'"], "id":1 }' http://localhost:8545

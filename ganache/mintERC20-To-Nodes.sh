nodelist="nodelist"
TOKENADDR=$1

DATASTART="0x40c10f19000000000000000000000000"
DATAEND="0000000000000000000000000000000000000000000000000de0b6b3a7640000"
ADDR=
while IFS= read -r line
do
  ADDR=$line
  DATA=$DATASTART$ADDR$DATAEND
  curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{ "from": "0xcD604B06F0A015269b34c2a8DC8C779535c24B2f", "gas": "0x2dc6c0", "to": "'$TOKENADDR'", "data":"'$DATA'"}], "id":1 }' http://localhost:8545
done < "$nodelist"

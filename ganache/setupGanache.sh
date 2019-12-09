echo "Step 1: Deploying ERC20 token..."
TOKENTX=`./deployERC20.sh | jq .result` &&
echo "Done. Formatting"
# remove new line and quotation marks
TOKENTX=${TOKENTX//$'\n'/}
TOKENTX="${TOKENTX%\"}"
TOKENTX="${TOKENTX#\"}"
echo "Step 2: Get token address..."
TOKENADDR=`./getTokenAddress.sh $TOKENTX | jq .result.contractAddress`
echo "Done. Formatting"
TOKENADDR=${TOKENADDR//$'\n'/}
TOKENADDR="${TOKENADDR%\"}"
TOKENADDR="${TOKENADDR#\"}"
echo $TOKENADDR
echo "Step 3: Minting ERC20 tokens for nodes..."
./mintERC20-To-Nodes.sh $TOKENADDR &&
echo "Step 4: Deploying ERC20 Factory..."
FACTORYTX=`./deployERC20Factory.sh $(echo $TOKENADDR | cut -c 3-) | jq .result` &&
#FACTORYTX=`./deployERC20Factory.sh $TOKENADDR | jq .result` &&
echo "Done. Formatting"
FACTORYTX=${FACTORYTX//$'\n'/}
FACTORYTX="${FACTORYTX%\"}"
FACTORYTX="${FACTORYTX#\"}"
echo "Step 5: Get factory address..."
./getFactoryAddress.sh $FACTORYTX

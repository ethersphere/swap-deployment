= Run a swap-enabled swarm node how-to

The first public incentives-enabled Swarm network runs on the ropsten network. 
It runs with network id **5**

== Prerequisites
* Create an account on ropsten
* Fund your newly created account with test coins

== Network setup

The public swap-enabled network currently runs 30 nodes on the kubernetes cluster, in the `swap-staging` namespace. 

== Bootnodes
The bootnodes for the public swap-enabled Swarm cluster run in separate VMs, they are independent, and are thus not deployed together with the cluster config. 

The addresses are 
```
enode://7f4d606c91d50d91fd09cb44f8b3d8033f1ca87e977a881e91d77ff6af98b6a52245ba9aeba13a39024ae8bdf3afa421fd018571ae37928c065d7a62503f17a6@3.122.203.99:40301

enode://7f4d606c91d50d91fd09cb44f8b3d8033f1ca87e977a881e91d77ff6af98b6a52245ba9aeba13a39024ae8bdf3afa421fd018571ae37928c065d7a62503f17a6@3.122.203.99:40301
```

Add these addresses with the `--bootnodes` when starting your node.


== Run your own swap-enabled node and connect to the cluster

=== Get Tokens
Getting tokens via the [faucet](https://ropsten.etherscan.io/address/0x49bf80bdee2684580966e476aee0dc3d773ffaf5=writeContract) is only possible *after* your start Swarm. To get tokens, first start Swarm, node down the address of the chequebook and call the `drip` function via the interface of etherscan, with the address of your chequebook as argument.

Note: the current faucet only allows to call the drip function one time per deployed chequebook contract. 

=== Start Swarm
Note: replace the `bzzkeyhex` with the private key of your funded `bzz-account` and replace the `--datadir` flag with your desired data directory for Swarm.

```
swarm --swap --swap-backend-url=https://ropsten.infura.io/v3/4f7e7287d52447ab8865dbdcf7c203e1 --swap-skip-deposit --ws --wsaddr=0.0.0.0 --wsorigins=* --wsapi=admin,net,debu    g,bzz,stream,accounting,swap --datadir /home/fabio/dat/swarm/swap-enabled --bzznetworkid 5 --bzzkeyhex 0C03CAE29D0D25A0DCF254E2AFAE7A8C137F887748AF21C53DBBF163CA367509 --verbosity 3 --bootnodes "enode://7f4d606c91d50d91fd09cb44f8b3d8033f1ca87e977a881e91d77ff6af98b6a52245ba9aeba13a39024ae8bdf3afa421fd018571ae37928c065d7a62503f17a6@3.122.203.99:40301,enode://7f4d606c91d50d91fd09cb44f8b3d8033f1ca87e977a881e91d77ff6af98b6a52245ba9aeba13a39024ae8bdf3afa421fd018571ae37928c065d7a62503f17a6@3.122.203.99:40301"
```

Upload to a remote node:
```
 swarm --bzzapi http://swarm-0-swap-staging.stg.swarm-gateways.net up Downloads/file.zip 
699736d0ebc494e1162334a427b5721b24030b123732d8f1d16e24e482ecba3b
```

Downloading the resulting hash from your local node:

```
wget localhost:8500/bzz:/699736d0ebc494e1162334a427b5721b24030b123732d8f1d16e24e482ecba3b/
```

Check balance on your local node

```
>$ echo '{"jsonrpc":"2.0","method":"swap_balances","params":[], "id":104}' | websocat ws://localhost:8546/ -n --one-message --origin localhost | jq
{
  "jsonrpc": "2.0",
  "id": 104,
  "result": {
    "10e14c08a7c873adb30516807c138781da76d284dbb7f12d27d95919f9da3d24": 0,
    "1913db38b3a9d8cf2a5110f4ab1fbd0b882f729063e456e76c874bf3bda49788": -488096051628,
    "292fb3f158a8313c0606df126bef393c0d49f1879f35a813e07fc370a95f318c": -81349341938,
    "2cf4f38451678a6276ab1ad7039f91c7ebe99beca2342132d80566148157702f": -744251831714,
    "4069823dc97610784f237c5189bb0047fa44fdb58050408186e76dfc678117e4": 0,
    "50b3e7aecb9348770b28fe846e6ccd4a65dc6a7e6fad7f32f386226fca0fbb05": -732144077442,
    "5e2e42c0a2476cd3a5df0ba0f361a077202d0a05d8885940f5731f11bd06e314": -81349341938,
    "817a6498af5f83c8b9bd7991523696ac82af0b19c68dd20c44dee128b04c24b4": -569445393566,
    "8449ac2043f5eb12b859bb909ae7632fc2c64da8f5c5b0e24726bfc2b3b73683": 0,
    "8e14175898416068388ee88ac1b51b03c64c0f32ffd02bcfc5c40dc38a8273f4": -162698683876,
    "9e2d5a87d089d32996ccc650e29caf6827dd31349ae779d643438eb6a64bae57": 0,
    "ac370a71c55dbae1eda0c41406f36db04967230f5a6d53a8ca00a96d560b25e9": -650794735504,
    "b0b4283f1b00d9b12f9b57639175505d1e2db46ff553d393c6b79fbaa1eb5877": 0,
    "c13d2f0b212b2b2b7f4414be742ed361d63725fa571c7b04c562b980242372e2": 0,
    "c3faaf2ff61edbe4bece896467aa517989c82bcddcc9e4a0b7cc91ef991adc82": -1233143154257,
    "d196803f49ac650598a606a3417b19c80d234e71a79c98881b9bb75359aebe6b": 0,
    "e75b3b14877058c9f4d6884fb0be474f9d42864aa0b430fac62c46d3058ba38d": -4636912490466,
    "ed57d9d24f898731b928466ad05aeedeb698a82ad5e7f4a86a217b37a1190bbc": -416804432270
  }
}
```

Obviously this puts you negative, you can also upload local and download from remote

List of public remote node addresses

`kubectl -n swap-staging get ingress`

Note: this cluster is running latest master, we may want to update nodes for some time until we have some stable version, and then switch to use latest, which would correspond to releases


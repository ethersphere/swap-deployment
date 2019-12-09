## Deployment of ganache for testing

This folder contains some scripts to setup ganache.
**Note: the ganache instance is shared**

All custom deployments and the `swap-testing` namespace use the same accounts and the same ganache instance.

The current ganache instance is configured to setup 30 nodes and prefund them with test ETHs.

To deploy ganache, run
` helmsman -f helmsman-private-ganache.yaml --show-diff --apply`
to destroy, run
` helmsman -f helmsman-private-ganache.yaml --show-diff --destroy`

After deployment, you only get a barebone `ganache` instance.
This instance needs to be setup and configured for an incentivized Swarm network:
* Deploys an ERC20 token
* Mints ERC20 tokens for each configured address
* Deploys the ERC20 factory

Without these steps, a private swarm network won't run.

To run an automated setup for all this steps, first map the remote ganache port to a port on your local machine.
*The scripts assume localhost:8545*
`kubectl -n ganache port-forward pod/ganache-0 8545:8545`

then, in another terminal, run

`./setupGanache.sh`

This script executes a series of independent scripts.
If all goes well, you should get at the end an address printed in the command line, e.g.
`0x070055a77771f0e6741dfc6af6949a398bb3b05c`
This is the address of the factory.
This address needs to be set on the 
`--swap-chequebook-factory` flag for custom cluster nodes.

If this parameter is not set correctly, the node will not boot.

The `nodelist` file contains a list of the public keys of the preconfigured nodes.
All files should be placed in the same directory.

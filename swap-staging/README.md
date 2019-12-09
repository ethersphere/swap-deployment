== Deployment of `swap-staging` cluster

This folder contains the scripts for deploying the `swap-staging` public incentivized Swarm cluster.


To deploy run

```helmsman -f helmsman-public-swap.yaml --show-diff --apply```

to shutdown, run:

```helmsman -f helmsman-public-swap.yaml --show-diff --destroy```

The [ connect.md ] file contains instructions on how to connect to this public incentivized network from a local node.

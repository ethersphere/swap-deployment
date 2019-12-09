## Deployment of `swap-testing` cluster

This folder contains the scripts for deploying the `swap-testing` private incentivized Swarm cluster.


To deploy run

```helmsman -f helmsman-private-swap.yaml --show-diff --apply```

to shutdown, run:

```helmsman -f helmsman-private-swap.yaml --show-diff --destroy```

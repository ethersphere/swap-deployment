## Custom cluster deployment

This folder contains scripts for the deployment of a custom incentivized private Swarm cluster.

The cluster connects with the `ganache` instance deployed independently.
The `--swap-chequebook-factory` flag for the nodes needs to come from the setup and deployment of the ganache instance.
The current node config version is compatible with the ganache instance deployed.

Should the ganache instance be changed (e.g. different contract data), most likely the ganache installation needs to be updated, resulting in a different contract address, which needs to be adjusted at the above flag.

### IMPORTANT
A custom deployment is meant for an individual test only, for example before merging to `master`, or individual experimentation.
**Make sure to free the resources (`--destroy`) when you are done**, in order to minimize unncessary payments due to wasting resources (the cluster infrastructure runs on AWS).


### Configuration
For your own deployment, change the following settings:
* in `helmsman-custom-private-swap.yaml`:
  * Change namespace:
     Under `namespaces`, replace `custom` with an own namespace name, usually your @ or your name (e.g. rpicc, holisticode, etc.)
     * Do **not remove** the `kube-system` entry
  * In `tillerNamespace`, replace `custom` with your own namespace (same as above)
  * In `namespace`, replace `custom` with your own namespace (same as above)

  * set.replicaCount:
     This defines the number of nodes for your deployment; the default is 30, but you can change this value to your needs

* in `swarm-custom-private-swap.yaml`
  *  ```
      swarm:
        image:
          repository: ethersphere/swarm
          tag: edge
      ```
      Set the `tag` entry to the appropriate value for your commit **TBD**


### Deployment

To deploy the cluster, run

```
helmsman -f helmsman-custom-private-swap.yaml --show-diff --apply
```

To check if the deployment was successful, run

`kubectl -n custom get pods` (replace `custom` with your namespace)

This retrieves the list of all pods deployed in the given namespace. 
Verify that the `STATUS` column has all nodes as `RUNNING`.

If there is a problem, you can try checking the individual node's logs by executing
`kubectl -n custom logs -c swarm swarm-private-2` to get the logs for the node named `swarm-private-2` 

To shutdown the cluster and free its resources, run

```
helmsman -f helmsman-custom-private-swap.yaml --show-diff --destroy
```


### Interaction with the cluster

The cluster is configured to offer publicly available http addresses for interaction via the `ingress` config.

To get a list of all publicly available http addresses of nodes:

`kubectl -n custom get ingress`

A typical result of this call if the cluster is deployed:

`swarm-private-10   swarm-private-10-custom.stg.swarm-gateways.net   107.23.251.127,3.231.168.49,54.158.57.42   80, 443   25m`

For every node deployed there should be an entry.

For node `swarm-private-10`, the public endpoint is `swarm-private-10-custom.stg.swarm-gateways.net`


To upload a file to a node, e.g. `swarm-private-10`:

` swarm --bzzapi http://swarm-10-custom.stg.swarm-gateways.net up /path/to/your/file/name.zip`

Download using your favourite cli tool, e.g. `wget` or `curl`.

` wget http://swarm-24-custom.stg.swarm-gateways.net/bzz:/699736d0ebc494e1162334a427b5721b24030b123732d8f1d16e24e482ecba3b`

To check if a node has any peers, it's possible to log in into a node:

```
kubectl exec -n custom -ti swarm-private-4 -- sh
/ # geth attach /root/.ethereum/bzzd.ipc
> admin.peers
```

A reference for more commands, port mappings etc. can be found at [  https://github.com/ethereum/swarm-cluster/blob/master/kubernetes/USER-GUIDE.md ]


The configuration for this cluster is set to include the following services per default:
* `metricsEnabled: true`
   Metrics via `influxdb`. The metrics can be visualized via grafana. Map the port and then access the UI in your browser at localhost:3001:
   `kubectl -n custom port-forward service/swarm-private-grafana 3001:80`

* `tracingEnabled: true`
  Tracing via `jaeger`

*  `profilingEnabled: true`
  Profiling via `pprof`

You might decide to set any of these variables to `false` to save on resources (and faster deployment time).


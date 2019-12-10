# Deployment helm charts and scripts for swap-enabled Swarm clusters #

## Overview
**This repo is work in progres.**

This repository contains a collection of support scripts for deployments and the setup of **swap-enabled Swarm** clusters.

The Swarm repository is hosted at [ http://github.com/ethersphere/swarm ]

Swarm is a p2p incentivized storage and communication platform for a truly sovereign digital society.
Its p2p nature poses unique requirements for development and testing of its features.
Swarm already has several repositories for the setup and configuration of clusters.

However, the implementation of the *incentivization* infrastructure for Swarm requires additional complexity when deploying nodes for testing.
As the incentivization layer is being worked on in parallel to the optimization and evolution of the Swarm network, there is an overlapping phase where testing of incentives-related functionality is independent of the core Swarm network development.

This repo contains the documentation and the scripts needed for running incentivized Swarm nodes.

At some point into the future, this will become the *main mode of operation* for Swarm nodes, at which time this repository may be reorganized or even become obsolete.
It is a work in progress of service mainly for the incentives track of the Swarm development team.

## Prerequisites
 * Kubernetes
   For the setup and configuration of kubernetes and its `kubectl` executable, refer to [ https://github.com/ethersphere/swarm-kubernetes/blob/master/USER-GUIDE.md ]
 * Helm (package manager for kubernetes)
   Installation instructions in the same guide above
 * Helmsman
   Automation helper for the management of helm scripts.
   This is actually *optional*, but - this guide uses `helmsman` for the deployment, and the scripts herein work with `helmsman` only!
   Installation:
   ** Linux users: check first your distro's package manager, it may be supported. E.g. Arch linux/Manjaro: `yay -S helmsman-bin`
   ** The source can be found at [ https://github.com/Praqma/helmsman ]

## Environments
This guide distinguishes between the following environments (each one with their own kubernetes namespace):

### `swap-staging`
This is a *public swap-enabled* cluster.
This means that everyone can connect to it from anywhere.

It has some *long-running* character and should have a **release** based deployment, which means to re-deploy it only after some official release. 
Note: As the release schedule for swap-enabled nodes is not yet clearly defined, such "official" releases are as of yet undefined.

It should mimic the *main Swarm deployment* of Swarm 1.0.

When Swarm 1.0 is released, it should have:
* a Mainnet
* a Testnet

So `swap-staging` could become the **Testnet** of an incentived Swarm 1.0.

The actual Mainnet infrastructure needs to be defined approaching 1.0, as there is already a non-incentivized public Swarm network running. The devops decisions about main and testnet deployments will finally have impact on `swap-staging`.

For the time being, it plays the following roles during development:
* Practice backward compatibility and maintenance of a network
* Allowing developers to connect own nodes to a public incentivized Swarm network for individual testing and experimentation
* Allowing interested 3rd party to interact with an incentivized Swarm network (although we are currently **not** publicly inviting people to do this).

This is a **unstable** network per definition for the time being. 
Any cryptocurrency on this network is purely for testing purposes. **Do not use for any financially critical activity**. 

The blockchain used is **ropsten** - any crypto used in the context of this network is fictitious and can be lost.

The `swap-staging` folder contains scripts for the deployment of this incentivized public network. 


### `swap-testing`
This is a *private swap-enabled* cluster.
This means that it is not meant to be accessed from outside.

It runs 30 nodes. It is meant for **testing** only by the developers.

It can be shutdown and restarted by anyone in the team at any time. If you suspect activity by some other team member, consider informing the channel.

It always runs latest `master`. After merging a PR it should be updated by the merging developer.

It does not need to run at all times (saving resources), but can be started at developer's discretion to quickly test some functionality on `master`.

This network uses **ganache** as the blockchain.
There is one instance of ganache deployed in its own namespace. with prefunded accounts.

The `swap-testing` folder contains scripts for the deployment of this `master` based private network.


### Custom environment
This is a *private development* cluster environment.
It is meant to test branches *before* a merge to master.

Every developer wanting to merge to master would deploy this under his *own namespace*.
It should be a one-off deployment; after finishing the test, the cluster should be shut down.
**Please make sure to shutdown the cluster after finishing in order to save on resources**. 
This is very important in order to not have to make Swarm incur in unnecessary payments for unused resources.

Such a dev network also uses **ganache** as blockchain backend.
In fact, it *shares* all accounts between the `swap-testing` cluster and every other dev cluster.

The dev cluster differs from `swap-testing` only in:
* the namespace
* the version to use (commit hash)

The `custom` folder contains sample scripts for the deployment of such dev private networks.

### ganache ###
There is a separate ganache deployment which is **shared** between all dev clusters and the `swap-testing` clusters.
This needs to be so because the setup of a ganache instance to work with Swarm is quite complex:
* deploy the actual ganache instance
* pre-fund accounts with (test) ETH
* deploy the ERC20 contracts
* premint accounts with ERC20 tokens
* deploy the factory

Especially the last point is important, as it contains the factory address needed to start swap-enabled dev nodes.
That address needs to be configured via command-line parameters to the dev nodes.

If nothing changes affecting ganache (contracts), the factory address will remain the same.
The currently configured address in the dev Swarm nodes scripts works with the current version of ganache and need not be changed.

However, if there should be a change to contract code, most likely that factory address **needs to be changed in the deployment scripts**.

The `ganache` folder contains the scripts for the setup and deployment of ganache as well as the contracts.

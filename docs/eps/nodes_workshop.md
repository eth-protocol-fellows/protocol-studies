# Study Group Lecture | Using Ethereum clients  

During Day 3, apart of [the regular presentation](https://epf.wiki/#/eps/week3), [Mario](https://twitter.com/TMIYChao) prepared a workshop to give you a hands-on experience of using Ethereum clients. We will learn how to spin up an Ethereum node by running execution and consensus client. 

You can [join us for the live workshop](https://meet.ethereum.org/eps-office-hours) on Wednesday after regular Office Hours at 3PM UTC or watch the recording of the workshop from last year.

[recording](https://www.youtube.com/embed/KxXowOZ2DLs?si=yLpNoczrUmxj4kE4 ':include :type=iframe width=100% height=560 frameborder="0" allow="fullscreen" allowfullscreen encrypted-media gyroscope picture-in-picture web-share')

Make sure to prepare your environment and learn basics necessary to understand the process: 

## Prerequisites

Get yourself familiar with Ethereum client architecture as described in Day 1 and you can check Day 2 and 3 for even better understanding of what workshop executes. The workshop will default to geth+lighthouse but if you have other preferred client to try, make yourself familiar with its documentation. 

- https://ethereum.org/en/developers/docs/nodes-and-clients/node-architecture/
- https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/
- Client documentation of your preferred client pair 
- Basic bash/cli shell skills 
    - https://btholt.github.io/complete-intro-to-linux-and-the-cli/, https://ubuntu.com/tutorials/command-line-for-beginners
- Make yourself familiar with [Ephemery testnet](https://ephemery.dev)

### Prepare your enviroment 

To follow the workshop, make sure to prepare your environment. 

- Update the system and install dependencies so it doesn't block you during the workshop.  
- Install basic utils we will need like curl, git, gpg, docker
- Install compilers for languages of clients you'd like to try to compile (we default to using prebuilt binaries)
- The workshop environment will be a fresh Debian 12 instance but you can use any preferred distro, Mac or WSL. Process might be very similar on other unix based systems and you can always setup a VM to replicate the same environment. 

We will only run a client on testnet so the hardware requirements are minimal - the goal of the workshop is not to sync the tip of the chain but only demonstrate how the node works. Default client pair will be geth+lighthouse but if there is enough time we can demonstrate switching the pair. 

## Outline

- Introduction to running nodes
    - Choosing a client pair and environment
- Obtaining clients 
    - Downloading and verifying binary
    - Compiling a client? 
    - Docker setup? 
- Client pair setup
    - Run EL+CL client on Holesky
    - Running on Ephemery using custom genesis 
    - Switching CL or EL client
        - Nimbus? 
        - Erigon? 
- Using the client
    - Accessing the RPC
        - http, console, wallet
        - Adding validators 
- Additional exercise if there is time
    - Systemd service
    - Monitoring node
- Join the [Office Hours call](https://meet.ethereum.org/eps-office-hours) to follow the workshop, ask questions and get help with troubleshooting.

## Additional reading and exercises 

There are bunch of things we are not going to demonstrate during the workshop so you can try them yourself afterwards. 

- Setup monitoring with Grafana dashboard which shows detailed information on various client parameters and functions
- Enable higher logs verbosity, read client debug logs to learn about its low level processes 
- Connect to your node using a wallet, development tooling, web3.py or JS console 
- Connect your node to the [crawler](https://www.ethernets.io/help/) and check what details it learns about it, discover new peers

- https://github.com/eth-educators/ethstaker-guides/blob/main/holesky-node.md
- https://notes.ethereum.org/@launchpad/node-faq-merge
- https://www.coincashew.com/coins/overview-eth/guide-or-how-to-setup-a-validator-on-eth2-mainnet/part-i-installation/monitoring-your-validator-with-grafana-and-prometheus





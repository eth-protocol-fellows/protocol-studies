# Study Group Week 5 | Using Ethereum clients  

During week 5, apart of [the regular presentation](https://epf.wiki/#/eps/week5), we prepared a workshop to give you a hands-on experience of using Ethereum clients. We will learn how to spin up an Ethereum node by running execution and consensus client. 


Watch the recording of the workshop by [Mario](https://twitter.com/TMIYChao) on StreamEth or Youtube. 

[recording](https://www.youtube.com/embed/KxXowOZ2DLs?si=yLpNoczrUmxj4kE4 ':include :type=iframe width=100% height=560 frameborder="0" allow="fullscreen" allowfullscreen encrypted-media gyroscope picture-in-picture web-share')

Make sure to prepare your enviroment and learn basics necessary to understand the process: 

## Prerequisites

Get yourself familiar with Ethereum client architecture as described in Week 1 and you can check Week 2 and 3 for even better understanding of what workshop executes. The workshop will default to geth+lighthouse but if you have other preferred client to try, make yourself familiar with its documentation. 

- https://ethereum.org/en/developers/docs/nodes-and-clients/node-architecture/
- https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/
- Client documentation of your preferred client pair 
- Basic bash/cli shell skills 
    - https://btholt.github.io/complete-intro-to-linux-and-the-cli/, https://ubuntu.com/tutorials/command-line-for-beginners

Prepare your environment, update the system and install dependencies so it doesn't block you during the workshop.  

- The workshop environment will be fresh Debian 12 instance but you can use any preferred distro. Process might be very similar on other unix based systems like Mac but you can always setup a VM to replicate the environment. 
- Install basic utils we will need like curl, git, gpg, docker, compilers 

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
- After the stream, we can switch to [jitsi](meet.ethquokkaops.io/EPFsgWorkshop) for further discussion and troubleshooting

## Additional reading and exercises 

There are bunch of things we are not going to demonstrate during the workshop so you can try them yourself afterwards. 

- Setup monitoring with Grafana dashboard which shows detailed information on various client parameters and functions
- Enable higher logs verbosity, read client debug logs to learn about its low level processes 
- Connect to your node using a wallet, development tooling, web3.py or JS console 
- Connect your node to the [crawler](https://www.ethernets.io/help/) and check what details it learns about it, discover new peers

- https://github.com/eth-educators/ethstaker-guides/blob/main/holesky-node.md
- https://notes.ethereum.org/@launchpad/node-faq-merge
- https://www.coincashew.com/coins/overview-eth/guide-or-how-to-setup-a-validator-on-eth2-mainnet/part-i-installation/monitoring-your-validator-with-grafana-and-prometheus





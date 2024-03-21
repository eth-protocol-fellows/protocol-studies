# Study Group Week 5 | Using Ethereum clients  

During week 5, apart of [the regular presentation](https://epf.wiki/#/eps/week5), we prepared a workshop to give you a hands-on experience of using Ethereum clients. We will learn how to spin up an Ethereum node by running execution and consensus client. 

Join the workshop by [Mario Havel](https://github.com/TMIYChao) on [Thursday, March 21, 4PM UTC](https://savvytime.com/converter/utc-to-germany-berlin-united-kingdom-london-ny-new-york-city-ca-san-francisco-china-shanghai-japan-tokyo-australia-sydney/mar-21-2024/4pm).

The workshop be streamed live on [StreamEth](https://streameth.org/65cf97e702e803dbd57d823f/epf_study_group) and Youtube, links will be provided before the call in the [Discord server](https://discord.gg/Tg2PryVJ). The workshop will be live so you can prepare your own setup, follow the workshop and ask questions in discord group. 

Make sure to prepare your enviroment and learn basics necessary to understand the process: 

## Prerequisites

Get yourself familiar with Ethereum client architecture as described in Week 1 and you can check Week 2 and 3 for even better understanding of what workshop executes. The workshop will default to geth+lighthouse but if you have other preffered client to try, make yourself familiar with its documentation. 

- https://ethereum.org/en/developers/docs/nodes-and-clients/node-architecture/
- https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/
- Client documentation of your prefered client pair 
- Basic bash/cli shell skills 
    - https://btholt.github.io/complete-intro-to-linux-and-the-cli/, https://ubuntu.com/tutorials/command-line-for-beginners

Prepare your enviroment, update the system and install dependencies so it doesn't block you during the workshop.  

- The workshop enviroment will be fresh Debian 12 instance but you can use any prefered distro. Process might be very similar on other unix based systems like Mac but you can always setup a VM to replicate the enviroment. 
- Install basic utils we will need like curl, git, gpg, docker, compilers 

We will only run a client on testnet so the hardware requirements are minimal - the goal of the workshop is not to sync the tip of the chain but only demostrate how the node works. Default client pair will be geth+lighthouse but if there is enough time we can demostrate switching the pair. 

## Outline

- Introduction to running nodes
    - Choosing a client pair and enviroment
- Obtaining clients 
    - Downloading and verifying binary
    - Compiling a client? 
    - Docker setup? 
- Client pair setup
    - Run EL+CL client on Holesky
    - Running on Ephemery uing custom genesis 
    - Switching CL or EL client
        - Nimbus? 
        - Erigon? 
- Using the client
    - Accessing the RPC
        - http, console, wallet
        - Adding validators 
- Additional excercies if there is time
    - Systemd service
    - Monitoring node
- After the stream, we can switch to [jitsi](meet.ethquokkaops.io/EPFsgWorkshop) for further discussion and troubleshooting

## Additional reading and exercises 

There are bunch of things we are not going to demostrate during the workshop so you can try them yourself afterwards. 

- Setup monitoring with Grafana dashboard which shows detailed information on various client parameters and functions
- Enable higher logs verbosity, read client debug logs to learn about its low level processes 
- Connect to your node using a wallet, development tooling, web3.py or JS console 
- Connect your node to the [crawler](https://www.ethernets.io/help/) and check what details it learns about it, discover new peers

- https://github.com/eth-educators/ethstaker-guides/blob/main/holesky-node.md
- https://notes.ethereum.org/@launchpad/node-faq-merge
- https://www.coincashew.com/coins/overview-eth/guide-or-how-to-setup-a-validator-on-eth2-mainnet/part-i-installation/monitoring-your-validator-with-grafana-and-prometheus





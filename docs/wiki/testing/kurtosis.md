# Kurtosis testing

> :warning: This article is a [stub](https://en.wikipedia.org/wiki/Wikipedia:Stub), help the wiki by [contributing](/contributing.md) and expanding it.

[Kurtosis](https://www.kurtosis.com/) is a development and testing platform designed to package and launch environments of containerized services efficiently. Users are able to deploy these services exactly the way they want them with one line commands. Developers and testers can create consistent, scalable environments for distributed applications, quickly and consistently set up complex environments locally or remotely on kubernetes clusters leveraging [Kurtosis](https://github.com/kurtosis-tech/kurtosis) which ensures that their testing and development processes are streamlined and ready for production.

Deployment with Kurtosis:

- [Local Deployment with Docker](https://docs.kurtosis.com/#:~:text=Local-,Deploy,-on%20Docker%E2%80%8B)

- [Local deploy with feature flag and different numbers of each service](https://docs.kurtosis.com/#:~:text=different%20numbers%20of-,each,-service%E2%80%8B)

- [Remote Deployment using Kubernetes](https://docs.kurtosis.com/#:~:text=Remote-,deploy,-on%20Kubernetes%E2%80%8B)

If you would like to learn more, check out [Kurtosis](https://docs.kurtosis.com/quickstart)

Kurtosis is important in Ethereum Development as it is used as a build system for multi-container test environments that allows developers to easily create reproducible Ethereum network instances locally. The [Ethereum Kurtosis package](https://github.com/kurtosis-tech/ethereum-package) enables the rapid setup of a customizable, scalable, and private Ethereum testnet using Docker or Kubernetes. It supports all major Execution Layer (EL) and Consensus Layer (CL) clients, efficiently managing local port mappings and service connections for validation and testing of Ethereum core infrastructure.

For a deeper dive into Kurtosis, check out this [post](https://ethpandaops.io/posts/kurtosis-deep-dive/)

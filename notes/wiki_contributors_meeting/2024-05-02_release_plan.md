# Wiki Contributors Meeting #2 - May 02, 2024 (4PM UTC)

## Agenda

- Progress since last call, reflecting on the current state of the wiki
  - Active issues and PRs
- Sharing the wiki publicly
  - Outstanding tasks before releasing current wiki version
  - Community maintenance and versioning  

## Participants

- Asli
- Gorondan
- Hopinheimer
- Kira
- Manas
- Mario
- Nagu
- Rahul
- Raa
- Siddharth

## Notes

- Mario: Welcome everyone. Lets quickly review open pull requests.
- Mario to Gorondan: Please notify me when your PRs are ready for review.
- Gorondan: Execution tickets will take me a few days, but #169 can be merged.
- Mario: Rahul, great work on Formal verification. Ethereum's history is an important topic. The DAO and Parity hack provide important context. Anyone - feel free to pick that up.
- Mario to Nagu: Thank you for the quick response on SSZ and Merkleization. I'm open to merging it.
- Nagu: Sounds good.
- Mario: Gorondan, you've added warning stubs to some documents.
- Gorondan: I believe it's fair to have a warning that content is subject to change.
- Mario: I recall discussing with someone that important wiki pages should be future-proof. Feel free to add these warnings to relevant details pages. Let's also add instructions to `contributing.md` so we have it in one place.
- Siddharth: I'm wondering how to prioritize work, like the block building from week 1. I've been doing a lot of research lately. I was thinking of tackling EL Architecture next week, but it's a huge document. I think we should break it down for easier review.
- Mario: For things you have ready, feel free to submit a PR. The architecture is crucial for specs. Kira worked on Consensus architecture, so it would be nice if both architectures follow the same structure. The lowest priority would be the Geth thing.
- Siddharth: Then I'll finish the EL Architecture, specs, and then Geth. Specs are fairly simple. As an aside, I learned a lot from reviewing Geth.
- Mario: Rory is working on testing.
- Gorondan: Hopinheimer is working on the protocol design.
- Mario: Right. Some of the suggested topics are not necessary. I'll comment on the issue. It's important to cover design rationale. It's not covered anywhere.
- Mario: We should ensure single pages are lean for maintainability.
- Gorondan: I'm interested in Light client. If we start a page, Dirk can work on it.
- Mario: There is a stub page. Feel free to open an issue and work on it.
- Gorondan: Is the page about execution or..?
- Mario: It's explained in the page. It's just an RPC verifier using data from an independent beacon node.
- Rahul: Protocol overview is a priority for me. I got nerd sniped by Mario's lecture on Linux history and cryptopunks.
- Mario: The biggest missing piece is testing. We should document hive or different testing mechanisms.
- Kira: I kind of [wrote a condensed version of the yellow paper](https://hackmd.io/@kira50/H1O4tO6WC). In case someone would like to review it.
- Mario: Very cool. We should have it in the wiki. Feel free to open an issue and work on it.
- Hopinheimer: I have an open issue on dev-p2p and am planning to catch up with it this weekend.
- Mario: I would suggest Angus. He worked on networking and consensus and spent a lot of time on dev-p2p.
- Hopinheimer: Sure. I'll ping him.
- Kira: Prism has a really cool search bar. Can we have something similar I worked on?
- Mario: We always had a search bar. With the new UI, it's improved. If there's nothing else, I think we're ready to share the wiki! Feel free to share it. With EPF starting soon, I think the wiki should serve as a good learning resource. Also, should we version releases? We want to offer people more stable content and maybe archive it. Thoughts?
- Rahul: We could semver it.
- Gorondan: Maybe we should do bi-weekly updates until it's mature, then after 1.0, we could version it.
- Mario: I think most changes are behind us, so it makes sense to somehow track changes. Two weeks seems like a big window. I think we should do a weekly release.
- Kira: We could version based on Ethereum forks?
- Raa: We could follow semver and have a mapping with Ethereum releases. New pages can increment the minor or patch version.
- Rahul: We could use Ethereum fork names followed by dates as versions, like how [evm.codes](https://www.evm.codes/) does it.
- Mario: Currently, Josh and I are the only maintainers of the GitHub repo. I'd like to have one or two more people. I vote Rahul and one more person. I'd like to add two reviewers to the workflow. Over time, we can have 3 or 4 people. We can also have a deployment action in GitHub. We'll reach out to some contributors for rewards. Details soon.
- Mario on upcoming conferences: EthBerlin is a hackathon. Prague is my home conference, now quite big with over 1000 people. You're all invited. I could get you some tickets. Then there's ETHCC. We'll focus on technical conferences. Lastly, I'll create a recurring event for this meeting every two weeks from now. Feel free to send me your email.
- Asli: I couldn't contribute much but looking forward to this.
- Mario: Feel free to get started. I'll see you in two weeks. Goodbye.

## Next Actions

- Gorondan: Follow up on PR readiness.
- Siddharth: Submit PRs for EL Architecture and specs.
- Kira: Work on open issues and maybe covering yellow page overview.
- Hopinheimer: Catch up on dev-p2p issue and involve Angus.
- Everyone: Share thoughts on versioning and release strategy.
- Mario: Reach out to potential additional maintainers and reviewers for the GitHub repo. Public launch of the wiki. Set up deployment action. Organize rewards for contributors.

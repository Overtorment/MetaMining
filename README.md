# MetaMetaMeta! Token

## Meta-mining on ethereum network concept 


## [DAPP hosted here](https://overtorment.github.io/MetaMining/)

**Yo dawg. I heard you like mining... So I put a PoW mining inside 
Ethereum ERC20 token so you can mine tokens while you mine Ether!**

Imagine standard ERC20-compliant token on Ethereum platform.
Now, lets add simple proof-of-work check inside token contract, and reward whoever solves the
PoW task with tokens. Bam! You've got lightweight implementation of Bitcoin on top of Ethereum.
Isn't it meta?

Ofcourse its just for fun only. Mining (spending computational resources) doesn't protect the 
network from attacks (Ethereum network is already protected with its own mining), so it's only
a tokens distribution to miner (and those tokens are useless and worth nothing).

Bonus! You can mine in your browser. I made a [tiny Dapp](https://overtorment.github.io/MetaMining/) for that. Requires [Metamask](https://metamask.io/) plugin.
M4K3 M1N1ИG GЯE4T 4G41И!


### Current specs

* 2.5 min block time (I know, there's no blocks here, its just a figure of speech)
* Block reward: 5 tokens
* Decimals: 8 (digits after dot)
* Halving each: 210,000 blocks (1 year?)
* Difficulty retarget: each block; simple (exactly as in bitcoin-core)
* Algo: sha3 (aka keccak256)
* Max cap: count yourself (mining wont stop after 64 halvings as in bitcoin-core)  

### This repo

Includes Contract (.sol file) source and Dapp source.
License: WTFPL


## TODO:


* [x] ~~ERC20 compatible token~~
* [x] ~~PoW check function~~
* [x] ~~PoW target difficulty adjustment~~
* [x] ~~Reward halving~~
* [x] ~~Mining in browser tab (metamask integration?)~~
* [ ] Someone review sources
* [ ] Contract update (new version deployment), preserving all users tokens


## Discussions posted
* https://bitcointalk.org/index.php?topic=2196804.msg22078128 
* https://www.reddit.com/r/ethdapps/comments/71kdov/metamining_on_ethereum_network_concept/
* http://forum.ethereum.org/discussion/15604/meta-mining-on-ethereum-network-concept/p1
* https://www.reddit.com/r/ethereum/comments/796mfn/first_erc20_token_you_can_m1ne_in_browser/
* https://www.reddit.com/r/ethdev/comments/79a0hd/first_erc20_token_you_can_m1ne_in_browser_xpost/

To be discussed:
---------------

* Pre-mine: zero
* total supply: 
    * 21 mln ? (bitcoin)
* How many decimals ? 8. (100,000,000 satoshis per btc)
* token name? `Meta Bitcoin` ?
* token ticker? `META` ? `MET` ? `MBT`
* block reward: 
    * 50 coins ? (bitcoin)
    * 5
* block time:
    * 10 min ? (bitcoin)
    * 2.5 min
    * tied to ethereum block time (~17 sec) ?
* reward halving
    * 4 years ? (bitcoin) - (The Bitcoin block mining reward halves every 210,000 blocks)
    * 1 year (4 times faster)
* POW algo
    * sha256 ? (bitcoin)
    * sha3 ? (native thereum, + solidity & web3 built-in)
    * dynamic chain of different hashes? (is it asic-resistant?)  e.g. `sha256(keccak256(ripemd160(header+nonce)))`
* Difficulty target change
    * 2 weeks ? (bitcoin) - its 2016 blocks in bicoin
    * each block ? (much simpler)
    * avg of several N blocks ?
    * kimoto grawity well ? (to be investigates)
    * https://medium.com/@Mengerian/bringing-stability-to-bitcoin-cash-difficulty-adjustments-eae8def0efa4
* pow hash from ... ?
    * `block.coinbase`(current block miner’s address) + `block.timestamp`. Pros - no need to store value (random seed). Cons - changes too fast (every eth block, ~17 sec)
    * store `randomness`. Cons: each transaction will require more gas to overwrite it.
    * Dont store `randomness`. Hash senders pub address + smth else??

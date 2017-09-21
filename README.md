Meta-mining on ethereum network concept 
=======================================

## [DAPP hosted here](https://overtorment.github.io/MetaMining/)

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
* block time:
    * 10 min ? (bitcoin)
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
* * pow hash from ... ?
    *  `block.coinbase`(current block miner’s address) + `block.timestamp`. Pros - no need to store value (random seed). Cons - changes too fast (every eth block, ~17 sec)
    *  store `randomness`. Cons: each transaction will require more gas to overwrite it.


TODO:
----

* [x] ~~ERC20 compatible token~~
* [x] ~~PoW check function~~
* [x] ~~PoW target difficulty adjustment~~
* [x] ~~Reward halving~~
* [x] ~~Mining in browser tab (metamask integration?)~~
* [ ] Contract update (new version deployment), preserving all users tokens

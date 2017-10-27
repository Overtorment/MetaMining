/*

Meta Mining Token

https://github.com/Overtorment/MetaMining

*/

import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/PausableToken.sol";

pragma solidity ^0.4.17;

contract MetaToken is PausableToken {

    string public name = 'MetaMetaMeta! Token';
    uint8 public decimals = 8;
    string public symbol = 'M3T';
    string public version = '0.4.0';

    uint256 public blockReward = 1 * (10**uint256(decimals));
    uint32 public halvingInterval = 210000;
    uint256 public blockNumber = 0; // how many blocks mined
    uint256 public totalSupply = 0;
    uint256 public target   = 0x0000ffff00000000000000000000000000000000000000000000000000000000; // i.e. difficulty. miner needs to find nonce, so that (hash(nonce+random) < target)
    uint256 public powLimit = 0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint40 public lastMinedOn; // will be used to check how long did it take to mine
    uint256 public randomness;

    address public newContractAddress;

    function MetaToken() Ownable() {
        lastMinedOn = uint40(block.timestamp);
        updateRandomness();
    }

    /// update randomness, will be used to find next Nonce
    function updateRandomness() internal {
        randomness = uint256(sha3(sha3(uint256(block.blockhash(block.number-1)) + uint256(block.coinbase) + uint256(block.timestamp))));
    }

    /// returns `randomness` used in PoW calculations
    function getRamdomness() view returns (uint256 currentRandomness) {
        return randomness;
    }

    /// pure, accepts randomness & nonce and returns hash as int (which should be compared to target)
    function hash(uint256 nonce, uint256 currentRandomness) pure returns (uint256){
        return uint256(sha3(nonce+currentRandomness));
    }

    /// pure, accepts randomness, nonce & target and returns boolian whether work is good
    function checkProofOfWork(uint256 nonce, uint256 currentRandomness, uint256 currentTarget) pure returns (bool workAccepted){
        return uint256(hash(nonce, currentRandomness)) < currentTarget;
    }

    // accepts Nonce and tells whether it is good to mine
    function checkMine(uint256 nonce) view returns (bool success) {
        return checkProofOfWork(nonce, getRamdomness(), target);
    }

    /*
        accepts nonce aka "mining field", checks if it passess proof of work,
        rewards if it does
    */
    function mine(uint256 nonce) whenNotPaused returns (bool success) {
        require(checkMine(nonce));

        Mine(msg.sender, blockReward, uint40(block.timestamp) - uint40(lastMinedOn)); // issuing event to those who listens for it

        balances[msg.sender] += blockReward; // giving reward
        blockNumber += 1;
        totalSupply += blockReward; // increasing total supply
        updateRandomness();

        // difficulty retarget:
        var mul = (block.timestamp - lastMinedOn);
        if (mul > (60*2.5*2)) {
            mul = 60*2.5*2;
        }
        if (mul < (60*2.5/2)) {
            mul = 60*2.5/2;
        }
        target *= mul;
        target /= (60*2.5);

        if (target > powLimit) { // difficulty not lower than that
            target = powLimit;
        }

        lastMinedOn = uint40(block.timestamp); // tracking time to check how much PoW took in the future
        if (blockNumber % halvingInterval == 0) { // time to halve reward?
            blockReward /= 2;
            RewardHalved();
        }

        return true;
    }

    function setNewContractAddress(address newAddress) onlyOwner {
        newContractAddress = newAddress;
    }

    event Mine(address indexed _miner, uint256 _reward, uint40 _seconds);
    event RewardHalved();
}

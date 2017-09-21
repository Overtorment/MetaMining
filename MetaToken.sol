/*

Meta Mining Meta Token

based on https://github.com/ConsenSys/Tokens/blob/master/contracts/

.*/

import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract MetaToken is StandardToken {

    string public name = 'MetaMetaMeta! Token';
    uint8 public decimals = 8;
    string public symbol = 'M3T';
    string public version = '0.3.7';

    uint256 public blockReward = 5 * (10**uint256(decimals));
    uint32 public halvingInterval = 210000;
    uint256 public blockNumber = 0; // how many blocks mined
    uint256 public totalSupply = 0;
    uint256 public target   = 0x0000ffff00000000000000000000000000000000000000000000000000000000; // i.e. difficulty. miner needs to find nonce, so that (hash(nonce+random) < target)
    uint256 public powLimit = 0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint40 public lastMinedOn; // will be used to check how long did it take to mine
    uint256 public randomness;

    /// constructor
    function MetaToken() {
        lastMinedOn = uint40(block.timestamp);
        updateRandomness();
    }

    /// update randomness, will be used to find next Nonce
    function updateRandomness() {
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
    function mine(uint256 nonce) returns (bool success) {
        require(checkMine(nonce));

        Mine(msg.sender, blockReward, uint40(block.timestamp) - uint40(lastMinedOn) ); // issuing event to those who listens for it

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
        }

        return true;
    }


    event Mine(address indexed _miner, uint256 _reward, uint40 _seconds);

    /* taken from HumanStandardToken.sol */
    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        return true;
    }
}

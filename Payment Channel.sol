pragma solidity >=0.5.0;

contract PaymentChannel {
    address payable public sender;      // the account sending payments
    address payable public recipient;   // the account receiving the payments
    uint256 public expiration;          // timeout in case the recipient never closes the channel



   
    constructor (address payable _recipient, uint256 duration) public payable {
        sender = msg.sender;
        recipient = _recipient;
        expiration = now + duration;
    }


  
    function isValidSignature(uint256 amount, bytes memory signature) internal view returns (bool){
        bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));
        return recoverSigner(message, signature) == sender;
    }



    function close(uint256 amount, bytes memory signature) public {
        require(msg.sender == recipient);
        require(isValidSignature(amount, signature));
        recipient.transfer(amount);
        selfdestruct(sender);
    }



    function extend(uint256 newExpiration) public {
        require(msg.sender == sender);
        require(newExpiration > expiration);
        expiration = newExpiration;
    }



    // if the timeout is reached without the recipient closing the channel,
    // then the Ether is released back to the sender.
    function claimTimeout() public {
        require(now >= expiration);
        selfdestruct(sender);
    }
}
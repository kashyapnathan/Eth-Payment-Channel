# Eth-Payment-Channel
A sender creates a smart contract and puts funds in escrow in the contract
The recipient is guaranteed to receive funds because the smart contract escrows the Ether and honors a valid signed message for withdrawal.
The sender and receiver decide how long to keep the payment channel open. 
The smart contract contains a timeout so the sender is guaranteed to eventually recover funds even if the recipient refuses to close the channel.

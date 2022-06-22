# @version >=0.3.2

# @notice Simple contract to receive tips

event Payment:
    sender: indexed(address)
    amount: uint256
    bal: uint256

owner: address

# @notice Set owner address when the contract is created
@external
def __init__():
    self.owner = msg.sender

# @notice Default function is executed on a call to the contract if
# - non-existing function is called
# - no function is supplied, such as when someone sends it Eth directly
# Same construct as fallback in Solidity
@external
@payable
def __default__():
    log Payment(msg.sender, msg.value, self.balance)

# @note Function to deposit ETH in the contract
@external
@payable
def deposit():
    # @dev Emit payment event
    log Payment(msg.sender, msg.value, self.balance)

# @note Function to withdraw all Ether from this contract
@external
def withdraw():
    # @dev Get amount of ether stored in contract
    _amount:uint256 = self.balance
    # @dev Send all Ether to owner and emit payment event
    log Payment(self, _amount, self.balance)
    send(self.owner, _amount)

# @note Owner can use this method to transfer Eth from contract to an input recipient
@external
def transfer(_to:address, _amount:uint256):
    assert msg.sender == self.owner, "You are not the owner"
    assert _amount < self.balance, "Amount exceeds balance"
    log Payment(self, _amount, self.balance)
    send(_to, _amount)

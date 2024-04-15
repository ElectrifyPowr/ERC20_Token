from brownie import Token, accounts

def main():
    account = accounts[0]  # Use the first account
    token = Token.deploy(1_000_000, {'from': account})
    print(f"Deployed at {token.address}")
    tx = token.tx
    print(f"Transaction hash: {tx.txid}")
    print(f"Block number: {tx.block_number}")
    print(f"Gas used: {tx.gas_used}")

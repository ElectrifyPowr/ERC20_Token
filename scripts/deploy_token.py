from brownie import Token, accounts

def main():
    account = accounts[0]  # Use the first account
    token = Token.deploy(1_000_000, {'from': account})
    print(f"Deployed at {token.address}")

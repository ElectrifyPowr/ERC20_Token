def test_initial_supply(accounts, Token):
    token = Token.deploy(1_000_000, {'from': accounts[0]})
    assert token.totalSupply() == 1_000_000 * 10**18

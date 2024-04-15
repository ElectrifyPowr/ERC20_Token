// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
When this contract is deployed:
    - The initial supply of tokens is minted and assigned to the deployer's address.
    - The token can be transferred to other addresses, and each user can approve others
      to spend tokens on their behalf, which are standard functionalities in any ERC-20 token.
*/


// error fix: https://forum.openzeppelin.com/t/error-compiling-brownie-with-openzeppelin/24433/4
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, ERC20Capped, Pausable {
    // constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
    //     _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    // }

    constructor(uint256 cap, uint256 initialSupply) 
    ERC20("CoolToken", "CTK") ERC20Capped(cap * (10 ** decimals())) {
        require(initialSupply <= cap, "Initial supply exceeds cap");
        // _mint() -> mints the initial supply of tokens
        // 
        // msg.sender is the address deploying the contract, who will receive the initial supply
        // 
        // ERC-20 tokens often use 18 decimals, which is the same as Ethereum's native Ether, 
        // allowing for fractional values of the token
        //
        // '**' means by power of -> exp: 10**5 -> 10^5
        //
        // decimal() -> By default, this is set to 18 in OpenZeppelin's implementation. 
        // This means the token can be divided down to 0.000000000000000001 of a token
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function mint(uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= cap(), "Cap exceeded");
        _mint(_msgSender(), amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override(ERC20, ERC20Capped, Pausable)
    {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}

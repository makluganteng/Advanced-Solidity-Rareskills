// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract TokenGodMode is ERC20, Ownable {
    // Here we need to make a A special address is able to transfer tokens between addresses at will.

    address public immutable ADMIN_ADDRESS;

    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol) Ownable(msg.sender){
        ADMIN_ADDRESS = msg.sender;
        _mint(msg.sender, 100 * 10 ** uint256(decimals));
    } 

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual override returns (bool) {
        if (msg.sender == ADMIN_ADDRESS) {
            ERC20._transfer(from, to, value);
            return true;
        }
        return ERC20.transferFrom(from, to, value);
    }
}   

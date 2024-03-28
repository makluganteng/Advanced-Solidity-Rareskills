// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/// @title A Token Sanction contract that allows an admin to blacklist a user so that the user cant recieve the token.
/// @author V.O.T
/// @notice Use this contract only when u need a ERC20 to be controlled and able to blacklist user.
/// @dev All function is implemented with no side effects.
contract TokenSanction is ERC20, Ownable {

    mapping(address => bool) public blacklistedUser;

    /// @notice When a user is blacklisted it will emit this event.
    /// @dev This is to easily track the user that is blacklisted through event.
    /// @param user the user that is blacklisted.
    event Blacklisted(address indexed user);

    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol) Ownable(msg.sender){
        _mint(msg.sender, 100 * 10 ** uint256(decimals));
    }

    /// @notice Override the update function to check and make sure the blacklisted user is not getting any token and cant transfer any token.
    /// @dev Override the _update function from the ERC20.sol contract.
    /// @param from is basically the address of whom the token is coming from.
    /// @param to is the destination of where the token is being send to.
    /// @param value is the value of the token that is being send to.
    function _update(address from, address to, uint256 value) internal override {
        require(!blacklistedUser[to], "User is blacklisted");
        require(!blacklistedUser[from], "User is blacklisted");
        super._update(from, to, value);
    }

    /// @notice A function to blacklist a user where only the admin can only call.
    /// @dev This function is public but there is a control access that only the admin can only access.
    /// @param blacklist_user which is the address of the user that is being blacklisted.
    function blacklist(address blacklist_user) public onlyOwner{
        blacklistedUser[blacklist_user] = true;
        emit Blacklisted(blacklist_user);
    }

    function check_blacklist(address blacklist_user) public view  returns (bool){
        return blacklistedUser[blacklist_user];
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;

contract MemoryAndStorage {
    mapping(uint256 => User) users;

    struct User {
        uint256 id;
        uint256 balance;
    }

    function addUser(uint256 id, uint256 balance) public {
        users[id] = User(id, balance);
    }

    function updateBalance(uint256 id, uint256 balance) public {
        User storage user = users[id];
        user.balance = balance;
    }

    function getBalance(uint256 id) public view returns (uint256) {
        return users[id].balance;
    }
}

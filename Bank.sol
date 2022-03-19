// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;
import "./Ownable.sol";

interface GovernmentInterface {
    function addTransaction(
        address _from,
        address _to,
        uint256 _amount
    ) external payable;
}

contract Bank is Ownable {
    GovernmentInterface governmentInstance =
        GovernmentInterface(0x417Bf7C9dc415FEEb693B6FE313d1186C692600F);

    mapping(address => uint256) balance;

    event depositDone(uint256 amount, address indexed depositedTo);

    function deposit() public payable returns (uint256) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint256 amount) public onlyOwner returns (uint256) {
        require(balance[msg.sender] >= amount);
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    function transfer(address recipient, uint256 amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");

        uint256 previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        governmentInstance.addTransaction{value: 1 ether}(
            msg.sender,
            recipient,
            amount
        );

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
}

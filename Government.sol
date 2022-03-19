// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract Government {
    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 txId;
    }

    Transaction[] transactionLog;

    function addTransaction(
        address _from,
        address _to,
        uint256 _amount
    ) external payable {
        transactionLog.push(
            Transaction(_from, _to, _amount, transactionLog.length)
        );
    }

    function getTransaction(uint256 _index)
        public
        view
        returns (
            address,
            address,
            uint256
        )
    {
        return (
            transactionLog[_index].from,
            transactionLog[_index].to,
            transactionLog[_index].amount
        );
    }
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract MultisigWallet {
    uint256 limit;
    address[] public owners;

    struct Transfer {
        address startedBy;
        uint256 amount;
        uint256 approvals;
        address payable receiver;
        bool completed;
        uint256 id;
    }

    event TransferRequestCreated(
        uint256 _id,
        uint256 _amount,
        address _initiator,
        address _receiver
    );
    event ApprovalReceived(uint256 _id, uint256 _approvals, address _approver);
    event TransferApproved(uint256 _id);

    modifier onlyOwners() {
        bool owner;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                owner = true;
                break;
            }
        }
        require(owner);
        _;
    }

    Transfer[] transferRequests;

    mapping(address => mapping(uint256 => bool)) approvers;

    constructor(address[] memory _owners, uint256 _limit) {
        limit = _limit;
        owners = _owners;
    }

    function deposit() public payable {}

    function createRequest(uint256 _amount, address payable _receiver)
        public
        onlyOwners
    {
        emit TransferRequestCreated(
            transferRequests.length,
            _amount,
            msg.sender,
            _receiver
        );
        transferRequests.push(
            Transfer(
                msg.sender,
                _amount,
                0,
                _receiver,
                false,
                transferRequests.length
            )
        );
    }

    function approveRequest(uint256 _index) public onlyOwners {
        Transfer storage request = transferRequests[_index];
        require(transferRequests.length > _index, "No request available");
        require(!request.completed, "Request is completed Already");
        require(approvers[msg.sender][_index] == false, "Already approved");
        request.approvals += 1;
        approvers[msg.sender][_index] = true;
        emit ApprovalReceived(_index, request.approvals, msg.sender);

        if (request.approvals >= limit) {
            request.completed = true;
            request.receiver.transfer(request.amount);
            emit TransferApproved(_index);
        }
    }

    function getTransferRequests() public view returns (Transfer[] memory) {
        return transferRequests;
    }
}

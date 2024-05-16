// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

contract MyContract is zContract, OnlySystem {
    SystemContract public systemContract;
    uint256 constant BITCOIN = 18332; 

    constructor(address systemContractAddress) {
        systemContract = SystemContract(systemContractAddress);
    }

    function onCrossChainCall(
        zContext calldata context,
        address zrc20,
        uint256 amount,
        bytes calldata message
    ) external virtual override onlySystem(systemContract) {
        address targetTokenAddress;
        bytes memory recipientAddress;

        if (context.chainId == BITCOIN) {
            targetTokenAddress = BytesHelperLib.bytesToAddress(message, 0);
            recipientAddress = abi.encodePacked(
                BytesHelperLib.bytesToAddress(message, 20);
            )
        }
      
}

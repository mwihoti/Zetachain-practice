// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

contract omContract is zContract, OnlySystem {
    SystemContract public systemContract;

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
            );
        } else {
            (address targetToken, bytes memory recipient) = abi.decode(
                message,
                (address, bytes)
            );
            targetTokenAddress = targetToken;
            recipientAddress = recipient;
        }

        (address gasZRC20, uint256 gasFee) = IZRC20(targetTokenAddress).withdrawGasFee();

        uint256 inputForGas = SwapHelperLib.swapTokensForExactTokens(
            systemContract,
            zrc20,
            gasFee,
            gasZRC20,
            amount
        );
        uint256 outputAmount = SwapHelperLib.swapTokensForExactTokens (
            systemContract,
            zrc20,
            amount - inputForGas,
            targetTokenAddress,
            0

        );
        IZRC20(gasZRC20).approve(targetTokenAddress, gasFee);
        IZRC20(targetTokenAddress).withdraw(recipientAddress, outputAmount)
      
}
}

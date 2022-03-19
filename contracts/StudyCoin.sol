//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract StudyCoin is ERC20 {
    using SafeERC20 for IERC20;
    IERC20 public donationToken;
    uint public dailyAmount;

    constructor(
        address _donationToken
    ) ERC20("StudyCoin", "STC") {
        donationToken = IERC20(_donationToken);
        dailyAmount = 5;
    }

    function confirmAttendance(address[] memory _attendants)
        public
    {
        require(_attendants.length * dailyAmount <= donationToken.balanceOf(address(this)),
            "Balance is not enough");
        for (uint256 index = 0; index < _attendants.length; index++) {
            donationToken.safeTransfer(_attendants[index], dailyAmount);
        }
    }

    function addDonationPoolBalance(uint256 _amount) public {
        require(_amount > 0, "Amount should be bigger than 0");

        donationToken.safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);
    }
}

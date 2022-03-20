//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Attendance.sol";

contract Educa is ERC20, AccessControl {
    using SafeERC20 for IERC20;
    IERC20 public donationToken;
    Attendance public attendance;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _lastTokenClaimed;

    uint public dailyAmount;

    constructor(
        address _donationToken
    ) ERC20("Educa", "EDC") {
        donationToken = IERC20(_donationToken);
        attendance = new Attendance();
        dailyAmount = 5;
    }

    function addDonationPoolBalance(uint256 _amount) public {
        require(_amount > 0, "Amount should be bigger than 0");

        donationToken.safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);
    }

    function confirmAttendance(address _student, string memory tokenURI)
        public
    {
        attendance.mintAttendance(tokenURI);
        donationToken.safeTransfer(_student, dailyAmount);
    }

    function claimAttendance() public {
        _burn(msg.sender, 1);
        _lastTokenClaimed.increment();
        attendance.safeTransferFrom(address(this),msg.sender, _lastTokenClaimed.current());
    }
}

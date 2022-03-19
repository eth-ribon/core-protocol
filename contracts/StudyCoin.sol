//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract StudyCoin is ERC1155 {
    using SafeERC20 for IERC20;
    IERC20 public donationToken;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _lastTokenClaimed;

    uint256 public constant STUDY_COIN = 0;
    uint public dailyAmount;

    constructor(
        address _donationToken
    ) ERC1155("") {
        donationToken = IERC20(_donationToken);
        dailyAmount = 5;
    }

    function addDonationPoolBalance(uint256 _amount) public {
        require(_amount > 0, "Amount should be bigger than 0");

        donationToken.safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, STUDY_COIN, _amount, "");
    }

    function confirmAttendance(address _student, bytes memory tokenURI)
        public
    {
        _tokenIds.increment();
        _mint(address(this), _tokenIds.current(), 1, tokenURI);
        donationToken.safeTransfer(_student, dailyAmount);
    }

    function claimNFT() public {
        _burn(msg.sender, STUDY_COIN, 1);
        _lastTokenClaimed.increment();
        safeTransferFrom(address(this),msg.sender, _lastTokenClaimed.current(), 1, "");
    }
}

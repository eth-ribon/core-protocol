//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Attendance is ERC721URIStorage {
    using SafeERC20 for IERC20;
    IERC20 public donationToken;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint lastTransferedId;

    constructor(
        address _donationToken
    ) public ERC721("Attendance", "ATC") {
        donationToken = IERC20(_donationToken);
    }

    function confirmAttendance(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newAttendanceId = _tokenIds.current();
        _mint(address(this), newAttendanceId);
        _setTokenURI(newAttendanceId, tokenURI);

        return newAttendanceId;
    }

    function addDonationPoolBalance(uint256 _amount) public {
        require(_amount > 0, "Amount should be bigger than 0");

        donationToken.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function merge() public {
        Sponsor percentage
        NFT BalanceOf
        Transfer NFT (loop FROM lastTransferedId to _tokenIds.current)
            _tokenIds.current
            - lastTransferedId
            - Send the money to the responsible (NFT ID)
            - Send the NFT to the sponsor (NFT ID)
            - updatedlastTransferedId
    }
}

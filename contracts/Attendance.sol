//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

contract Attendance is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _lastTokenClaimed;

    constructor() ERC721("Attendance", "ATC") {}

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mintAttendance(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newAttendanceId = _tokenIds.current();
        _mint(msg.sender, newAttendanceId);
        _setTokenURI(newAttendanceId, tokenURI);

        return newAttendanceId;
    }
}

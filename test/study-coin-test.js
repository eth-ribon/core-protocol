const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("StudyCoin", () => {
  describe("When run parameters correctly", () => {
    let studyCoin;
    let donationToken;

    beforeEach(async () => {
      const DonationToken = await ethers.getContractFactory("DonationToken");
      donationToken = await DonationToken.deploy();
      await donationToken.deployed();
      const StudyCoin = await ethers.getContractFactory("StudyCoin");
      studyCoin = await StudyCoin.deploy(donationToken.address);
      await studyCoin.deployed();
    })

    it("When adding pool balance", async () => {
      const [owner] = await ethers.getSigners();
      await donationToken.approve(studyCoin.address, 10);
      await studyCoin.addDonationPoolBalance(10);

      const balance = await studyCoin.balanceOf(owner.address, 0);

      expect(balance).to.equal(10);

    });
  });

  // it("Confirm attendance and transfer amount", async () => {
  //   await studyCoin.confirmAttendance(
  //     "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
  //     {
  //       "recipient": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
  //       "student": "Nathiely Macedo",
  //       "teacher": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
  //       "class": "Capoeira"
  //     }
  //   );
  //   expect(await studyCoin.balanceOf(studyCoin.address, 1));
  // });

  
});

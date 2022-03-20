/* eslint-disable prettier/prettier */
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Educa", () => {
  describe("When run parameters correctly", () => {
    let educa;
    let donationToken;
    let attendance;

    describe("Access Control", () => {
      it ("when the user is not onganization council member confirm attendance isn't able", async () => {
        const DonationToken = await ethers.getContractFactory("DonationToken");
        donationToken = await DonationToken.deploy();
        await donationToken.deployed();

        const userAddress = "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD";
        const Educa = await ethers.getContractFactory("Educa");
        educa = await Educa.deploy(donationToken.address, userAddress);
        await educa.deployed();
        
        attendance = await ethers.getContractAt('Attendance', await educa.attendance());

        await donationToken.approve(educa.address, 10);
        await educa.addDonationPoolBalance(10);
        await expect(educa.confirmAttendance(
          "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
          JSON.stringify(
            {
              "recipient": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "student": "Nathiely Macedo",
              "teacher": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "class": "Capoeira"
            }
          )
        )).to.be.reverted;
      });
    })

    beforeEach(async () => {
      const DonationToken = await ethers.getContractFactory("DonationToken");
      donationToken = await DonationToken.deploy();
      await donationToken.deployed();

      const [owner] = await ethers.getSigners();
      const Educa = await ethers.getContractFactory("Educa");
      educa = await Educa.deploy(donationToken.address, owner.address);
      await educa.deployed();
      
      attendance = await ethers.getContractAt('Attendance', await educa.attendance());
    })

    describe("Organization Council", () => {
      it("when adding organization to council", async function () {
        const [organization] = await ethers.getSigners();
        await educa.addOrganizationToCouncil(organization.address);

        expect(
          await educa.isOrganizationOnCouncil(organization.address)
        ).to.equal(true);
      });

      it("when removing nonProfit from whitelist", async function () {
        const [organization] = await ethers.getSigners();
        await educa.removeOrganizationFromCouncil(organization.address);

        expect(
          await educa.isOrganizationOnCouncil(organization.address)
        ).to.equal(false);
      });
    })

    describe("Add donation pool balance", () => {
      it("When adding pool balance", async () => {
        const [owner] = await ethers.getSigners();
        await donationToken.approve(educa.address, 10);
        await educa.addDonationPoolBalance(10);
  
        const balance = await educa.balanceOf(owner.address);
  
        expect(balance).to.equal(10);
      });
    });

    describe("Confirm Attendance", () => {
      beforeEach(async () => {
        await donationToken.approve(educa.address, 10);
        await educa.addDonationPoolBalance(10);
        await educa.confirmAttendance(
          "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
          JSON.stringify(
            {
              "recipient": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "student": "Nathiely Macedo",
              "teacher": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "class": "Capoeira"
            }
          )
        );
      })

      it("When attendance is confirmed correctly change contract ntf balance", async () => {
        expect(await attendance.balanceOf(educa.address)).to.equal(1);
      });

      it("When attendance is confirmed correctly store the right data", async () => {
        expect(await attendance.tokenURI(1)).to.equal(JSON.stringify(
          {
            "recipient": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
            "student": "Nathiely Macedo",
            "teacher": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
            "class": "Capoeira"
          }
        ));
      });
    })

    describe("Burn Token", () => {
      beforeEach(async () => {
        await donationToken.approve(educa.address, 10);
        await educa.addDonationPoolBalance(10);
        await educa.confirmAttendance(
          "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
          JSON.stringify(
            {
              "recipient": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "student": "Nathiely Macedo",
              "teacher": "0xC02F65D7B10700Df84308D35709e7fb6f2267DFD",
              "class": "Capoeira"
            }
          )
        );
        await educa.claimAttendance();
      })

      it("When the token is burned correctly change the token balance", async () => {
        expect(await attendance.balanceOf(educa.address)).to.equal(0);
      });

      it("When the token is burned corretly transfer the NFT", async () => {
        const [owner] = await ethers.getSigners();
        expect(await attendance.balanceOf(owner.address)).to.equal(1);
      })

    })
  });
});

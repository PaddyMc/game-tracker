pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./interface/FundTrackerInterface.sol";

contract FundTracker is FundTrackerInterface {
  using SafeMath for uint;

  event UpdatedBalance(address addressFunded, uint balanceETH);

  mapping(uint => address) mapFundedData;
  mapping(address => uint) funderFundedData;
  mapping(string => address[]) ipfsHashFunded;

  uint numberOfFunders = 0;
  uint totalETH = 0;

  /**
    Funders
  **/
  function fundGameOwner(string memory ipfsHash) public payable {
    require(msg.sender.balance >= msg.value, "not enough funds");
    //require(fullGameData[ipfsHash].owner != msg.sender, "owner cannot fund owned game");
    
    if(getAmountFundedByAddress(msg.sender) != 0){
      funderFundedData[msg.sender] = funderFundedData[msg.sender].add(msg.value);
      ipfsHashFunded[ipfsHash].push(msg.sender);
      totalETH = totalETH.add(msg.value);
      emit UpdatedBalance(msg.sender, funderFundedData[msg.sender]);
    } else {
      funderFundedData[msg.sender] = msg.value;
      ipfsHashFunded[ipfsHash].push(msg.sender);
      mapFundedData[numberOfFunders] = msg.sender;
      totalETH = totalETH.add(msg.value);
      numberOfFunders++;

      emit UpdatedBalance(msg.sender, funderFundedData[msg.sender]);
    }
    //fullGameData[ipfsHash].amountFunded = fullGameData[ipfsHash].amountFunded.add(msg.value);
    //fullGameData[ipfsHash].owner.transfer(msg.value);

    //emit UpdatedBalance(fullGameData[ipfsHash].owner, fullGameData[ipfsHash].amountFunded);
  }

  function getNumberOfFunders() public view returns (uint256) {
    return numberOfFunders;
  }

  function getTotalAmountFunded() public view returns (uint) {
    return totalETH;
  }

  function getAmountFundedByAddress(address funderAddress) public view returns (uint) {
    return funderFundedData[funderAddress];
  }

  function getAllFundersForGame(string memory ipfsHash) public view returns (address[] memory) {
    return ipfsHashFunded[ipfsHash];
  }

  function getFunderAddressByNum(uint position) public view returns (address) {
    return mapFundedData[position];
  }

  function getFunderDataByNum(uint position) public view returns (address, uint) {
    return (mapFundedData[position], funderFundedData[mapFundedData[position]]);
  }
}
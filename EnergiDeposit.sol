pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


contract EnergiDeposit { 
 
    struct Deposit {
        address payable staker;
        uint amount;
        uint timestamps;
        uint blockNum;
    }
 
    Deposit[] public funds;
 
    address public owner;
    
    //use block100 modifier to control access to the payout function
    modifier block100() {

        uint currentBlockDiff = getBlockDiff();
        require( currentBlockDiff >= 100 , "Error: Block difference must be >= 100");
        _;
    }

    function getBlockDiff() view public returns (uint) { 
        uint currentBlock = block.number;
        Deposit memory lastDeposit = getLastDeposit();
        uint  lastDepositBlockNum =  lastDeposit.blockNum;
        uint currentBlockDiff = currentBlock - lastDepositBlockNum;
        return currentBlockDiff;
    }

    function payout() public block100 {
        Deposit memory lastDeposit = getLastDeposit();
        address payable winner =  payable(lastDeposit.staker);
        winner.transfer(address(this).balance);
    }


    function numDeposits() public view returns(uint) {
        return funds.length;
    }

    function getLastDeposit() public view returns(Deposit memory) {
        return funds[funds.length-1];
    }

 
    constructor () public {
        owner = msg.sender;
    }
  
    
    function depositFunds() public payable{
        uint256 amount = msg.value;
        Deposit memory deposit = Deposit(msg.sender,amount, now, block.number);
        funds.push(deposit);
        /// your logic
    }
    
  
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }    
}

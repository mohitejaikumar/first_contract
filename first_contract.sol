// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable{

    address private _owner;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }
    
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view  returns (address) {
        return _owner;
    }

    function _checkOwner() internal view  {
        require(owner() == msg.sender);
    }
    
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    

    function transferOwnership(address newOwner) public  onlyOwner {
        require(owner() == msg.sender);
        _transferOwnership(newOwner);
    }


    function _transferOwnership(address newOwner) internal  {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


contract CourseRegistration is Ownable {

     uint256 public courseFee;
     Payment[] public payments;

     struct Payment {
        address user;
        string email;
        uint256 amount;
     }

     event PaymentSuccessfull(address user, string email, uint256 amount);

     constructor (uint256 _courseFee) Ownable(msg.sender){
      courseFee = _courseFee;
     }

     function payForCourse(string memory email) external payable{
       require(msg.value == courseFee); // check wether it is courseFee or something else 
       payments.push(Payment(msg.sender, email, msg.value));
       emit PaymentSuccessfull(msg.sender, email, msg.value);
     }

     function updateCourseFee(uint256 _newCourseFee) external onlyOwner{
          courseFee = _newCourseFee;
     }
     
     function withdraw() external onlyOwner{
        payable(owner()).transfer(address(this).balance);
     }

     function getAllPayments() external view returns (Payment[] memory){
       return payments;
     }

     function getPaymentByUser(address _userAddress) external view returns (Payment[] memory){
        uint count =0;
        for(uint i=0; i<payments.length; i++){
            if(payments[i].user == _userAddress){
                count++;
            }
        }
        
        Payment[] memory userPayments = new Payment[](count);
        
        count = 0;
        for(uint i=0; i<payments.length; i++){
            if(payments[i].user == _userAddress){
                userPayments[count] = payments[i];
                count++;
            }
        }
        return userPayments;
     }

}
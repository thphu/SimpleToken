pragma solidity ^0.4.18;


contract SimpleTokenI {
	function allowance(address owner, address spender) public view returns (uint256) { }
	function transferFrom(address from, address to, uint256 value) public returns (bool) { }
	function approve(address spender, uint256 value) public returns (bool) { }

	function totalSupply() public view returns (uint256) { }
	function balanceOf(address who) public view returns (uint256) { }
	function transfer(address to, uint256 value) public returns (bool) { }

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SIMDepositRelease {

	SimpleTokenI tokenAddress;
	address eventAddress;
	address storageAddress;

    function() payable {}

    function SIMDepositRelease(address _tokenAddress, address _eventAddress, address _storageAddress) {
    	tokenAddress = SimpleTokenI(_tokenAddress);
    	eventAddress = _eventAddress;
    	storageAddress = _storageAddress;
    }

    function callTransferFrom(address _sender, address _receiver, uint256 _amount) returns (bool) {
    	return tokenAddress.transferFrom(_sender, _receiver, _amount);
    	// return tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _sender, _receiver, _amount);
    }

    function onChange(uint256 _event, uint256 _type, address _from, address _to, uint256 _amount) public returns (bool) {
    	return eventAddress.call(bytes4(keccak256("onChange(uint256,uint256,address,address,uint256)")), _event, _type, _from, _to, _amount);
    }

	function deposit(uint256 _type, address _receiver, uint256 _amount) public payable {
        uint256 amount = _amount * 10 ** 18;
    	bool result = callTransferFrom(msg.sender, storageAddress, amount);
    	onChange(1, _type, msg.sender, _receiver, amount);
	}

	function release(address _receiver, uint256 _amount) public payable {
		// _type: 1 is eth, 2 is this
		uint256 amount = _amount * 10 ** 18;
		callTransferFrom(storageAddress, _receiver, amount);
		onChange(2, 2, storageAddress, _receiver, amount);
	}
}

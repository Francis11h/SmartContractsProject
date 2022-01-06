// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface ERC20TokenInterface {
    // function name() public view returns (string);
    // function symbol() public view returns (string);
    // function decimals() public view returns (uint8);

    // function totalSupply() public view returns (uint256);
    // function balanceOf(address _owner) public view returns (uint256 balance);
    // function transfer(address _to, uint256 _value) public returns (bool success);
    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    // function approve(address _spender, uint256 _value) public returns (bool success);
    // function allowance(address _owner, address _spender) public view returns (uint256 remaining);


    // event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _tokenOwner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _tokenValue) external returns (bool success);

    event Transfer(address indexed _addressFrom, address indexed _addressTo, uint256 _tokenValue );

    function approve(address _spender, uint256 _value) external returns (bool success);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Returns the amount which _spender is still allowed to withdraw from _owner.
    function allowance(address _tokenOwner, address _spender) external view returns (uint256 remaining);

    //Transfers amount of tokens from address _from to address _to, and must trigger the Transfer event.
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract Francis is ERC20TokenInterface {

    address public contractOwner;

    // why we can replace a function with a state variable?
    // cause solidity will also create a function for serving this state variable, when we call the state var, this var will automatically call the function
    uint public override totalSupply;
    /*
        function totalSupply() public view override returns (uint256) {
            return totalSupply;
        }
    */


    mapping(address => uint) public balances;
    //1st addr is owner, 2nd addr is spender,
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        contractOwner = msg.sender;
        totalSupply = 100000000;
        balances[contractOwner] = totalSupply;
    }

    function name() public pure returns (string memory){
        return 'Francis11h';
    }

    function symbol() public pure returns (string memory){
        return 'Francis';
    }

    function decimals() public pure returns (uint8){
        return 0;
    }

    // replaced by the totalSupply state variable
    // function totalSupply() external pure override returns (uint256) {
    //     return totalSupply;
    // }

    function balanceOf(address _tokenOwner) external view override returns (uint256 balance) {
        return balances[_tokenOwner];
    }

    function transfer(address _to, uint256 _tokenValue) external override returns (bool success) {
        require(balances[msg.sender] >= _tokenValue);
        balances[_to] += _tokenValue;
        balances[msg.sender] -= _tokenValue;
        emit Transfer(msg.sender, _to, _tokenValue);
        return true;
    }

    function approve(address _spender, uint256 _value) external override returns (bool success) {
        require(balances[msg.sender] >= _value);
        require(_value > 0);
        //sender to spender at most value
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _tokenOwner, address _spender) external view override returns (uint256 remaining) {
        return allowed[_tokenOwner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) external override returns (bool success) {
        require(allowed[_from][_to] >= _value);
        require(balances[_from] >= _value);

        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][_to] -= _value;
        return true;
    }


}
pragma solidity ^0.8.5;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

//继承 openzeppelin ERC20
contract MytokenOpenzeppelin is ERC20 {
    address public admin;

    //调用constructor 后 会自动调用 openzeppelin的 ERC20，传入初始化参数
    constructor() ERC20('MytokenOpenzeppelin', 'HZRZEP') {
        _mint(msg.sender, 10000 * 10 ** 18);
        admin = msg.sender;
    }

    function mint(address to, uint amount) external {
        require(msg.sender == admin, 'error!!!! only admin can mint'); //权限控制
        _mint(to, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MyToken {
    mapping(address => uint256) s_addressToBalance;

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_addressToBalance[_owner];
    }

    function transfer(address _to, uint256 amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_addressToBalance[msg.sender] -= amount;
        s_addressToBalance[_to] += amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
        require(balanceOf(msg.sender) > amount); //since gas fees are need
    }
}

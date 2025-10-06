// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract erc20 {
    mapping(address individuo => uint256 saldo) public saldosPorEndereco;
    mapping(address individuo => mapping(address endAprovado => uint256 valorAprovado))
        public aprovadoPorEndereco;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    constructor(uint256 valorInicial) {
        saldosPorEndereco[msg.sender] = valorInicial;
        emit Transfer(address(0), msg.sender, valorInicial);
    }

    function name() public pure returns (string memory) {
        return "ThiagoCoin";
    }

    function symbol() public pure returns (string memory) {
        return "THI$";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 100000e18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return saldosPorEndereco[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        transferHelper(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(aprovadoPorEndereco[_from][msg.sender] >= _value);
        aprovadoPorEndereco[_from][msg.sender] -= _value;
        transferHelper(_to, _from, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        aprovadoPorEndereco[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return aprovadoPorEndereco[_owner][_spender];
    }

    function transferHelper(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(saldosPorEndereco[_from] >= _value, "Saldo insuficiente");
        saldosPorEndereco[_from] -= _value;
        saldosPorEndereco[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
}

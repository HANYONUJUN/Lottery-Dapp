// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery{
    
    address public owner; // 주소를 owner로 설정

    constructor() public {
        owner = msg.sender; //배포를 할 때 보낸 사람으로 owner를 저장
    }

    function getSomeValue() public pure returns (uint256 value) {
        return 5;
    }
}
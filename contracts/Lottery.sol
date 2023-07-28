// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery{ 
    struct BetInfo {
        uint256 answerBlockNumber; // 맞추려고 하는 정답 block
        address payable bettor;  // 정답을 맞췄을 때 돈을 보내야 하는 주소 0.4.22버전 이상부터는 'payable' 붙여줘야함 아니면 transfer을 못함
        bytes1 challenges; // 0xab
    }

    uint256 private _tail;
    uint256 private _head;    
    mapping (uint256 => BetInfo) private _bets;
    
    address public owner; // 주소를 owner로 설정

    uint256 constant internal BLOCK_LIMIT =256;
    uint256 constant internal BET_BLOCK_INTERVAL = 3; //3번 block에 betting을 하게되면 6번 block에 betting을 하게 됨
    uint256 constant internal BET_AMOUNT = 5 * 10 ** 15;
    
    uint256 private _pot;


event BET(uint256 index, address bettor, uint amount, bytes1 challenges, uint256 answerBlockNumber);

    constructor() public {
        owner = msg.sender; //배포를 할 때 보낸 사람으로 owner를 저장
    }


    function getPot() public view returns (uint256 pot){
        return _pot;
    }

    
    /**
     * @dev 배팅을 한다. 유저는 0.005 ETH를 보내야 하고, 베팅용 1 byte 글자를 보낸다.
     * 큐에 저장된 베팅 정보는 이후 distribute 함수에서 해결된다.
     * @param challenges 유저가 베팅하는 글자
     * @return result 함수가 수행되었는지 확인하는 bool 값
     */
    function bet(bytes1 challenges) public  payable returns (bool result) {
        // 돈이 들어왔는지 확인
        require(msg.value == BET_AMOUNT, "Not enough ETH");

        // queue에 bet정보를 넣음
        require(pushBet(challenges), "Fail to add a new Bet Info");

        // event log를 출력
        emit BET(_tail -1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERVAL);

        return true;
    }
    


    //Distribute
      // check the answer
    

    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, bytes1 challenges){
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.answerBlockNumber;
        bettor =b.bettor;
        challenges = b.challenges;
    }

    function pushBet(bytes1 challenges) internal returns (bool) {
        BetInfo memory b;
        b.bettor = msg.sender;
        b.answerBlockNumber = block.number + BET_BLOCK_INTERVAL;   // 현재 이 트랜잭션 block의 들어있는 값을 불러올 수 있게 된다. 
        b.challenges = challenges;

        _bets[_tail] =b;
        _tail++;

        return true;
    }

    //delete를 쓰게 되면 gas를 돌려받게 됨
    // 스마트 컨트랙트 또는 이더리움 블록체인에 저장되어 있는 데이터를 더이상 저장하지 않겠다라는 의미
    function popBet(uint256 index) internal returns (bool) {
        delete _bets[index];
        return true;
    }
}
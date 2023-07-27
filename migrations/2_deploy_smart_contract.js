// smart_contract를 배포할 때의 명령어 truffle migrate 
// 처음엔 truffle migrate를 사용하지만 재배포를 할 시 --reset을 붙여주는게 좋음
// 원래 배포시 migrations폴더안에 있는 파일들의 순서대로 진행을 하지만 reset을 하면 처음부터 다시 진행함

const Lottery = artifacts.require("Lottery");

module.exports = function(deployer) {
  deployer.deploy(Lottery);
};

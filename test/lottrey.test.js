const Lottery = artifacts.require("Lottery");

//ganagche-cli를 실행했을 때 나타나는 10가지 주소를 받는 매개변수
contract('Lottery', function([deployer,user1, user2]){
    
    let lottery; // 배포를 위한 변수
    
    beforeEach(async () => {
        console.log('Before each')

        lottery = await Lottery.new(); // 배포 가능
    })

    it('Basic test', async () =>{
        console.log('Basic test')
        let owner = await lottery.owner();
        let value = await lottery.getSomeValue();

        console.log(`owner : ${owner}`); // 0번째 accounts 주소 값
        console.log(`value : ${value}`); 
        assert.equal(value, 5)
    })
});
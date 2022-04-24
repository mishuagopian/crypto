Moralis.initialize("dBGYfI09zieqifoeOJMld1x8GCxM9anK6eiLqLtg"); // Application id from moralis.io
Moralis.serverURL = "https://jmu7an3vn054.usemoralis.com:2053/server"; //Server url from moralis.io
const CONTRACT_ADDRESS = "0xA2a0c041943f3900Af4434CC31B487FC1b39011F";
let web3;

async function mint() {
    try {
      currentUser = Moralis.User.current();
      if (!currentUser){
        currentUser = await Moralis.Web3.authenticate();
      }

      await Moralis.enableWeb3();
      const web3 = new Web3(Moralis.provider);
      const accounts = await web3.eth.getAccounts();
      const contract = new web3.eth.Contract(contractAbi, CONTRACT_ADDRESS);

      const amount = parseInt(document.getElementById("#mint-amount").value);
      contract.methods.mint(amount).send({ from: accounts[0] });

    } catch (error) {
      console.log(error);
    }
}

document.getElementById("connect-navbar").onclick = mint;
document.getElementById("mint-button").onclick = mint;

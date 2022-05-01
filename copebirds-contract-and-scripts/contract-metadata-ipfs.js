let fs = require("fs");
let axios = require("axios");

let ipfsArray = [];

const contractMetadata = {
    path: 'contract-metadata.json',
    content: JSON.parse(fs.readFileSync(`${__dirname}/contract-metadata.json`, 'utf8'))
};

axios.post("https://deep-index.moralis.io/api/v2/ipfs/uploadFolder", 
    [contractMetadata],
    {
        headers: {
            "X-API-KEY": 'MORALIS_API_KEY',
            "Content-Type": "application/json",
            "accept": "application/json"
        }
    }
).then( (res) => {
    console.log(res.data);
})
.catch ( (error) => {
    console.log(error)
})

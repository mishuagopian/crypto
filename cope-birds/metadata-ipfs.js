let fs = require("fs");
let axios = require("axios");

let ipfsArray = [];
let promises = [];

for (let i = 0; i < 2; i++) {
    const obj = JSON.parse(fs.readFileSync(`${__dirname}/metadatas/${i}.json`, 'utf8'));

    ipfsArray.push({
        path: `/${i}.json`,
        content: {
            atttributes: obj['attributes'],
            image: `ipfs://QmZuot5Nhx4ePvvnb1DoGMBa1dF9bH4PLnkgHpboYeRTbj/${i}.png`,
            name: `CopeBirds #${i}`,
            description: "Awesome CopeBird"
        }
    })
}
axios.post("https://deep-index.moralis.io/api/v2/ipfs/uploadFolder", 
    ipfsArray,
    {
        headers: {
            "X-API-KEY": 'REPLACE_ME',
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

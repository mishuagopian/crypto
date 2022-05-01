let fs = require("fs");
let axios = require("axios");

let ipfsArray = [];
let promises = [];

for (let i = 0; i < 2; i++) {
  promises.push(new Promise( (res, rej) => {
      fs.readFile(`${__dirname}/images/${i}.png`, (err, data) => {
          if(err) rej();
          ipfsArray.push({
              path: `${i}.png`,
              content: data.toString("base64")
          })
          res();
      })
  }))
}

Promise.all(promises).then( () => {
  axios.post("https://deep-index.moralis.io/api/v2/ipfs/uploadFolder", 
      ipfsArray,
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
})

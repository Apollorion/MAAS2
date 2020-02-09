const axios = require('axios');
const database = require('./database');

let api = "https://cab.inta-csic.es/rems/wp-content/plugins/marsweather-widget/api.php";

exports.handler = async function(event, context, callback) {
    let data = await axios.get(api);
    let soles = data.data.soles;

    let highestSol = 0;
    for( let sol of soles ){
        await database.insertSol(sol);
        if(parseInt(sol["sol"]) > highestSol){
            highestSol = parseInt(sol["sol"])
        }
    }
    await database.updateLatestSol(highestSol);
};




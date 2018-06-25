let mysql = require('mysql');
let request = require('request');
let _ = require('lodash');

let connection = mysql.createConnection({
    host     : 'YOUR-HOST',
    user     : 'YOUR-USERNAME',
    password : 'YOUR-PASSWORD',
    database : 'YOUR-DATABASE'
});

let nasaAPI = 'https://cab.inta-csic.es/rems/wp-content/plugins/marsweather-widget/api.php';

let solNotFoundResponse = {status: 404, message: "Sol not found"};

connection.connect();

let getLatestSol = (callback) => {
    request({
        url: nasaAPI,
        json: true
    }, function (error, response, body) {
        if(error) throw error;
        getSol(body.soles[0].sol, (results) => {
            callback(results);
        });
    });
};

let getSpecificSolFromNasa = (solToFind, callback) => {
    request({
        url: nasaAPI,
        json: true
    }, function (error, response, body) {
        if(error) throw error;
        let specifiedSol = _.find(body.soles, { 'sol': solToFind });
        if(specifiedSol === undefined)
        {
            callback(solNotFoundResponse);
        }
        else
        {
            insertSol(specifiedSol, () => {
                getSol(solToFind, (result) => {
                    callback(result);
                });
            });
        }
    });
};

let insertSol = (solToInsert, callback) => {
    connection.query(
        'INSERT INTO MAAS SET ?',
        {
            sol: solToInsert.sol,
            season: solToInsert.season,
            min_temp: solToInsert.min_temp,
            max_temp: solToInsert.max_temp,
            atmo_opacity: solToInsert.atmo_opacity,
            sunrise: solToInsert.sunrise,
            sunset: solToInsert.sunset,
            min_gts_temp: solToInsert.min_gts_temp,
            max_gts_temp: solToInsert.max_gts_temp
        },
        function (error, results, fields) {
        if (error) throw error;
        callback();
    });
};

let getSol = (sol, callback) => {

    if(sol === 'latest')
    {
        console.log("GETTING LATEST SOL");
        getLatestSol((results) => {
            callback(results);
        });
    }
    else
    {
        connection.query(`SELECT * from MAAS WHERE sol='${sol}'`, function (error, results, fields) {
            if (error) throw error;
            if(results.length === 0)
            {
                console.log("GETTING SPECIFIC SOL FROM NASA");
                getSpecificSolFromNasa(sol, (result) => {
                    callback(result);
                });
            }
            else
            {
                console.log("FOUND SOL IN DB");
                callback({status: 200, ...results[0], unitOfMeasure: 'Celsius', TZ_Data: 'America/Port_of_Spain'});
            }
        });
    }
};

module.exports = {
    getSol
};
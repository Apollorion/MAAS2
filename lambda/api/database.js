const mysql = require('mysql');

const solNotFoundResponse = {status: 404, message: "Sol not found"};

module.exports.getSol = async (sol) => {

    // Place connection within function so lambda creates a new connection on every execution.
    const connection = mysql.createConnection({
        host     : process.env.mysqlHost,
        user     : process.env.mysqlUser,
        password : process.env.mysqlPass,
        database : process.env.mysqlDB
    });
    connection.connect();

    try {
        if(sol === "latest"){
            sol = await getLatestSol(connection);
        } else {
            sol = parseInt(sol);
        }

        let result = await getSolFromDB(connection, sol);
        connection.destroy();
        return result;
    } catch {
        connection.destroy();
        return solNotFoundResponse;
    }
};

async function getSolFromDB(connection, sol){
    return new Promise(async (resolve, reject) => {

        connection.query(
            'SELECT * FROM MAASv2 WHERE ? LIMIT 1',
            { sol },
            function (error, results, fields) {
                if (error){
                    reject();
                }
                if(results.length === 0){
                    resolve(solNotFoundResponse);
                } else {
                    resolve({status: 200, ...results[0], unitOfMeasure: 'Celsius', TZ_Data: 'America/Port_of_Spain'})
                }
            }
        );
    });
}

async function getLatestSol(connection){
    return new Promise((resolve, reject) => {
        connection.query(
            'SELECT sol FROM latest_sol WHERE ? LIMIT 1',
            { "id": 1 },
            function (error, results, fields) {
                if (error){
                    reject(error);
                    return;
                }
                resolve(results[0]["sol"])
            }
        );
    });
}
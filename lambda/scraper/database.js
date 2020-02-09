let mysql = require('mysql');

let connection = mysql.createConnection({
    host     : process.env.mysqlHost,
    user     : process.env.mysqlUser,
    password : process.env.mysqlPass,
    database : process.env.mysqlDB
});

connection.connect();

module.exports.insertSol = async (solToInsert) => {

    return new Promise((resolve, reject) => {

        let insertable = {};
        for(let param in solToInsert){
            if(solToInsert.hasOwnProperty(param)){
                // remove -- set as undefined
                let value = solToInsert[param];
                if(value === "--"){
                    insertable[param] = undefined;
                } else {
                    insertable[param] = value;
                }
            }
        }

        connection.query(
            'INSERT IGNORE INTO MAASv2 SET ?',
            insertable,
            function (error, results, fields) {
                if (error){
                    reject(error);
                    return;
                }
                resolve()
            }
        );
    });

};

module.exports.updateLatestSol = async (sol) => {
    return new Promise((resolve, reject) => {
        connection.query(
            'UPDATE latest_sol SET ? WHERE id=1',
            {
                sol
            },
            function (error, results, fields) {
                if (error){
                    reject(error);
                }
                resolve()
            }
        );
    });
};
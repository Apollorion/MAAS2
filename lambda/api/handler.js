const database = require('./database');

exports.handler = async function(event, context, callback) {

    let request = "latest";
    if("pathParameters" in event && event["pathParameters"] != null && "whatToGet" in event["pathParameters"]){
        request = event["pathParameters"]["whatToGet"];
    }

    let requestedSol = await database.getSol(request);

    return callback(null, {
        "isBase64Encoded": false,
        "statusCode": requestedSol["status"],
        "headers": { "Content-Type": "application/json; charset=utf-8" },
        "body": JSON.stringify(requestedSol)
    });
};

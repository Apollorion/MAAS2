// For development/testing purposes

let database = require('./database');

exports.handler = function(event, context, callback) {
    database.getSol(event.body, (result) => {
        context.succeed(result);
    });
};

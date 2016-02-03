
var fs = require('fs');
var express = require('express');
var ParseServer = require('parse-server').ParseServer;

var args = {
    databaseURI: process.env.PARSE_DATABASE_URI || 'mongodb://mongo:27017/parse',
    appId: process.env.PARSE_APP_ID,
    masterKey: process.env.PARSE_MASTER_KEY,
    javascriptKey: process.env.PARSE_JAVASCRIPT_KEY,
    restAPIKey: process.env.PARSE_REST_API_KEY,
    dotNetKey: process.env.PARSE_DOTNET_KEY,
    clientKey: process.env.PARSE_CLIENT_KEY
}

try {
    if (fs.statSync(__dirname + '/cloud/main.js').isFile()) {
        args.cloud = __dirname + '/cloud/main.js';
    }
} catch (e) { }

var api = new ParseServer(args);
var app = express();

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

var server = app.listen(1337, function() {
    console.log('parse-server running on port 1337.');
});

// Gracefully shutdown on docker stop
process.on('SIGTERM', function () {
    console.log('SIGTERM received. Shutting down.');
    server.close(function () {
        process.exit(0);
    });
});

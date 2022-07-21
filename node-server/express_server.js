#!/usr/bin/env node

const express = require('express');
const fs = require('fs');
const redis = require('redis');
const app = express();

const VERSION_FILE = "../VERSION";

if ( ! fs.existsSync(VERSION_FILE) ) {
    console.log("Version missing!");
    process.exit(1);
}
const version = fs.readFileSync(VERSION_FILE, 'utf8').trim();

// -----------

app["get"]('/', function (req, res) {
    res.send(`Hello World! (GET) ${version}\n`);
});

app["post"]('/', async function (req, res) {
    try {
        const client = redis.createClient({
            url: 'redis://primary.default.svc.cluster.local:6379'
        });
        await client.connect();

        const val = await client.incr("foo");
        res.send(`Hello World! (POST) version=${version} incr=${val}\n`);
    } catch ( ex ) {
        res.send(`Error! (POST) ${version} - ${ex}`);
    }
});

// Without this block of code, ctrl-c will not work, docker stop will hang for 10 seconds
process.on('SIGINT', () => {
    console.info("Interrupted");
    process.exit(0);
})

app.listen(3000, function () {
    console.log('Example app listening on port 3000!');
});

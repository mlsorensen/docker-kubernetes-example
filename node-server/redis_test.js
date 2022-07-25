#!/usr/bin/env node

const redis = require('redis');

// Nowhere can I find a way to map services to their DNS entry
// You just "have to know" that you're supposed to the name of the
// service and postpend "[namespace].svc.cluster.local".
// I tried "kubectl describe service primary"
// I tried "kubectl get services"
// NOWHERE did it mention "svc.cluster.local"
Promise.resolve().then(async () => {
    try {
        const client = redis.createClient({
            url: 'redis://primary.default.svc.cluster.local:6379'
        });
        await client.connect();
        const val = await client.incr("foo");
        console.log(`Hello World! incr=${val}\n`);
        process.exit(0);
    } catch ( ex ) {
        console.log(ex)
    }
});

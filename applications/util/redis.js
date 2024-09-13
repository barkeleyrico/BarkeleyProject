const redis = require("redis");

// Create Redis Client
const client = redis.createClient({
  socket: {
    host: "redis-cluster.default.svc.cluster.local", // Use the correct container name
    port: 6379,
  },
});

module.exports = client;

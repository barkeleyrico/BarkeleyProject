const express = require("express");
const redis = require("redis");

const client = require("./util/redis");

client
  .connect()
  .then(() => {
    console.log("Connected to Redis");
  })
  .catch((err) => {
    console.log("Error connecting to redis:", err);
  });

// Create an Express application
const app = express();
const PORT = 8000;

// Middleware to handle JSON
app.use(express.json());

// Initialize Redis and start the server
const getCounter = async () => {
  try {
    const key = "myCounter";
    const value = await client.get(key);

    if (value === null) {
      console.log("Initializing counter to 0");
      await client.set(key, 1);
      value = 1;
      return value;
    }

    // Increment the counter and display the new value
    const newValue = await client.incr(key);
    return newValue;
    //console.log(`New value of ${key}:`, newValue);
  } catch (err) {
    console.error("Error getting the value from Redis:", err);
    throw err;
  }
};

app.get("/", async (req, res) => {
  try {
    const data = await getCounter();
    res.send(`<h1>You are visitor number ${data}</h1>`);
  } catch (err) {
    res.send(`<h1>Internal Server Error</h1>`);
  }
});

app.listen(PORT, () => {
  console.log(`The server it's running on ${PORT}`);
});

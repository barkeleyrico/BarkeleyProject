const express = require("express");

const client = require("./util/redis");

const RETRY_ATTEMPTS = 10;
const RETRY_DELAY_MS = 5000; // 5 seconds

// client
//   .connect()
//   .then(() => {
//     console.log("Connected to Redis");
//   })
//   .catch((err) => {
//     console.log("Error connecting to redis:", err);
//   });

const connectWithRetry = async (attempts = RETRY_ATTEMPTS) => {
  try {
    await client.connect();
    console.log("Connected to Redis");
  } catch (err) {
    console.log(
      `Error connecting to Redis (attempt ${RETRY_ATTEMPTS - attempts + 1}):`,
      err
    );
    if (attempts <= 1) {
      throw err; // Fail after retries exhausted
    }
    // Wait before retrying
    await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
    await connectWithRetry(attempts - 1);
  }
};

connectWithRetry()
  .then(() => {
    // Create an Express application
    const app = express();
    const PORT = 8000;

    // Middleware to handle JSON
    app.use(express.json());

    const retryOperation = async (operation, attempts = RETRY_ATTEMPTS) => {
      try {
        return await operation();
      } catch (err) {
        console.log(
          `Error during Redis operation (attempt ${
            RETRY_ATTEMPTS - attempts + 1
          }):`,
          err
        );
        if (attempts <= 1) {
          throw err; // Fail after retries exhausted
        }
        // Wait before retrying
        await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
        return retryOperation(operation, attempts - 1);
      }
    };

    // Initialize Redis and start the server
    const getCounter = async () => {
      return retryOperation(async () => {
        const key = "myCounter";
        let value = await client.get(key); // Use let instead of const

        if (value === null) {
          console.log("Initializing counter to 0");
          await client.set(key, 1);
          value = 1; // No error here, as value is declared with let
          return value;
        }

        // Increment the counter and display the new value
        const newValue = await client.incr(key);
        return newValue;
      });
    };

    app.get("/healthz", (req, res) => {
      res.status(200).send("OK");
    });

    app.get("/", async (req, res) => {
      try {
        const data = await getCounter();
        res.send(`<h1>You are visitor number ${data}</h1>`);
      } catch (err) {
        res.send(`<h1>Internal Server Error</h1>`);
      }
    });

    app.listen(PORT, () => {
      console.log(`The server is running on ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Failed to connect to Redis after multiple attempts:", err);
    process.exit(1); // Exit if Redis connection fails
  });

// Update getCounter to use retryOperation

// // Create an Express application
// const app = express();
// const PORT = 8000;

// // Middleware to handle JSON
// app.use(express.json());

// // Initialize Redis and start the server
// const getCounter = async () => {
//   try {
//     const key = "myCounter";
//     let value = await client.get(key); // Use let instead of const

//     if (value === null) {
//       console.log("Initializing counter to 0");
//       await client.set(key, 1);
//       value = 1; // No error here, as value is declared with let
//       return value;
//     }

//     // Increment the counter and display the new value
//     const newValue = await client.incr(key);
//     return newValue;
//   } catch (err) {
//     console.error("Error getting the value from Redis:", err);
//     throw err;
//   }
// };

// app.get("/healthz", (req, res) => {
//   res.status(200).send("OK");
// });

// app.get("/", async (req, res) => {
//   try {
//     const data = await getCounter();
//     res.send(`<h1>You are visitor number ${data}</h1>`);
//   } catch (err) {
//     res.send(`<h1>Internal Server Error</h1>`);
//   }
// });

// app.listen(PORT, () => {
//   console.log(`The server it's running on ${PORT}`);
// });

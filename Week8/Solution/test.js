const app = require('./index');
const rand = Math.random();
if (rand < 0.2) {
  console.log("Test failed: Simulated error");
  process.exit(1);
}
console.log("Test passed: Express app loaded");
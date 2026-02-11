import { network } from "hardhat";

const { ethers, networkName } = await network.connect();

console.log(`Deploying TodoList to ${networkName}...`);

const todoList = await ethers.deployContract("TodoList");

console.log("Waiting for the deployment tx to confirm");
await todoList.waitForDeployment();

console.log("TodoList address:", await todoList.getAddress());

const tx = await todoList.addToDo(1, "GREET", "GOOD MORNING");

// console.log("Calling todoList add fn");
await tx.wait();
console.log("Tx:", tx);
// console.log("Waiting for the addTodo tx to confirm");

console.log("Deployment successful!");
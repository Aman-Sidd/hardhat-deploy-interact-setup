import { network } from "hardhat";

const { ethers, networkName } = await network.connect();

const signers = await ethers.getSigners();
console.log("SIGNER:", signers);
console.log("NETWORK NAME:", networkName);
// const TodoListFactory = await ethers.getContractFactory("TodoList");
// const todoList = await TodoListFactory.deploy();

const todoList = await ethers.getContractAt("TodoList", "0x5FbDB2315678afecb367f032d93F642f64180aa3");

const tx = await todoList.addToDo(2, "GREET 2", "GOOD NIGHT BRO!");
await tx.wait();
console.log("Tx successful:", tx)

const value = await todoList.getTodoWithId(2)

console.log(value);



import { network } from "hardhat";

const { ethers, networkName } = await network.connect();

const signers = await ethers.getSigners();
console.log("SIGNER:", signers);
console.log("NETWORK NAME:", networkName);
const todoList = await ethers.getContractAt("TodoList", "0x6312815af3CD29ACc4EE4F2FB8DE5C28F12F63Cf");

// const tx = await todoList.addToDo(2, "GREET 2", "GOOD NIGHT BRO!");
// await tx.wait();
// console.log("Tx successful:", tx)

const value = await todoList.getTodoWithId(2)

console.log(value);



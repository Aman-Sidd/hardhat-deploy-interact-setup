import hre, { network } from "hardhat";
import { verifyContract } from "@nomicfoundation/hardhat-verify/verify";


const { ethers, networkName } = await network.connect();


async function main() {

    console.log(`Deploying TodoList to ${networkName}...`);

    const todoList = await ethers.deployContract("TodoList");

    console.log("Waiting for the deployment tx to confirm");
    await todoList.waitForDeployment();

    const contractAddress = await todoList.getAddress();
    try{
        await verifyContract({
            address: contractAddress,
            constructorArgs:[],
            provider:"etherscan"
        }, hre)
        console.log("Successfully verified")
    } catch(e){
        console.log(e);
    }
        
    console.log("TodoList address:", await todoList.getAddress());

    const tx = await todoList.addToDo(1, "GREET", "GOOD MORNING");

    await tx.wait();
    console.log("Tx:", tx);

    console.log("Deployment successful!");
}



main()
    .then(() => process.exit(0))
    .catch((e) => {
        console.log(e);
        process.exit(1);
    })
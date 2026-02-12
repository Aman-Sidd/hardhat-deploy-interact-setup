import { expect } from "chai";
import { network } from "hardhat";
import type { TodoList } from "../types/ethers-contracts/index.js";

const { ethers } = await network.connect();

describe("TodoList Contract", async function () {
    let todoList: TodoList;

    beforeEach(async function () {
        todoList = (await ethers.deployContract("TodoList")) ;
        await todoList.waitForDeployment();
    })

    describe("Todo Actions", function () {
        it("Should not allow user to get non-existed todo", async function () {
            await expect(todoList.getTodoWithId(1)).to.be.revertedWith("No Todo Found with the given Todo ID");
        })

        it("Should allow user to create a new Todo", async function () {
            await todoList.addToDo(1, "TEST TITLE", "TEST DESCRIPTION");
            const todo = await todoList.getTodoWithId(1);
            expect(todo.title).to.equal("TEST TITLE");
            expect(todo.description).to.equal("TEST DESCRIPTION");
        })

        it("Should allow user to get their all Todos", async function () {
            await todoList.addToDo(1, "TEST TITLE 1", "TEST DESCRIPTION 1");
            await todoList.addToDo(2, "TEST TITLE 2", "TEST DESCRIPTION 2");
            await todoList.addToDo(3, "TEST TITLE 3", "TEST DESCRIPTION 3");

            const allTodos = await todoList.getAllTodos();

            expect(allTodos[1][0]).to.equal("TEST TITLE 1");
            expect(allTodos[2][0]).to.equal("TEST DESCRIPTION 1")
            expect(allTodos[1][1]).to.equal("TEST TITLE 2");
            expect(allTodos[2][1]).to.equal("TEST DESCRIPTION 2")
            expect(allTodos[1][2]).to.equal("TEST TITLE 3")
            expect(allTodos[2][2]).to.equal("TEST DESCRIPTION 3");
        })
    })
})
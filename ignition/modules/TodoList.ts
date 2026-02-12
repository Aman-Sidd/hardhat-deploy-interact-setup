import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("TodoList", (m) => {
    const todoList = m.contract("TodoList");

    // m.call(todoList, "addToDo", [1n, "GREET", "GOOD AFTERNOON!"]);

    return { todoList };
});
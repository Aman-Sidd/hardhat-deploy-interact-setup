import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("TodoList", (m) => {
    const counter = m.contract("TodoList");

    m.call(counter, "addToDo", [1n, "GREET", "GOOD AFTERNOON!"]);

    return { counter };
});
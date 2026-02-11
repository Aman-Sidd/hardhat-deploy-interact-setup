// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    struct Todo {
        string title;
        string description;
    }

    string[] titles;
    string[] descriptions;
    mapping(address => mapping(uint => Todo)) internal addressToTodos;
    mapping(address => uint[]) internal addressToTodoIds;
    mapping(address => mapping(uint => bool)) internal exists;

    function addToDo(
        uint _todoId,
        string memory _title,
        string memory _description
    ) public {
        address userAddress = msg.sender;
        if (exists[userAddress][_todoId]) {
            return;
        }
        Todo memory newTodo = Todo(_title, _description);
        addressToTodoIds[userAddress].push(_todoId);
        addressToTodos[userAddress][_todoId] = newTodo;
        exists[userAddress][_todoId] = true;
    }

    function getTodoWithId(uint _todoId) public view returns (Todo memory) {
        address userAddress = msg.sender;
        require(
            exists[userAddress][_todoId],
            "No Todo Found with the given Todo ID"
        );
        Todo memory todo = addressToTodos[userAddress][_todoId];
        return todo;
    }

    function getAllTodos()
        public
        view
        returns (uint[] memory, string[] memory, string[] memory)
    {
        address userAddress = msg.sender;
        uint[] memory todoIds = addressToTodoIds[userAddress];

        string[] memory _titles = new string[](todoIds.length);
        string[] memory _descriptions = new string[](todoIds.length);

        for (uint i = 0; i < todoIds.length; i++) {
            Todo memory todo = addressToTodos[userAddress][todoIds[i]];
            _titles[i] = todo.title;
            _descriptions[i] = todo.description;
        }

        return (todoIds, _titles, _descriptions);
    }

    function removeTodoId(uint _todoId) internal returns (bool) {
        address userAddress = msg.sender;
        uint[] storage todoIds = addressToTodoIds[userAddress];
        bool todoFound = false;
        for (uint i = 0; i < todoIds.length - 1; i++) {
            if (todoIds[i] == _todoId || todoFound) {
                todoFound = true;
                todoIds[i] = todoIds[i + 1];
            } else {
                continue;
            }
        }
        if (todoIds[todoIds.length - 1] == _todoId) {
            todoIds.pop();
            todoFound = true;
        }
        return todoFound;
    }

    function removeTodo(uint _todoId) public {
        address userAddress = msg.sender;
        require(
            exists[userAddress][_todoId],
            "No Todo Found with the given Todo ID"
        );
        delete addressToTodos[userAddress][_todoId];
        removeTodoId(_todoId);
    }
}

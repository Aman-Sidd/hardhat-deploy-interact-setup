// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

error TodoNotFound(uint256 todoId);

/// @title Todo List Smart Contract
/// @author Aman
/// @notice Allows users to create, view, and manage their personal todo items.
/// @dev Each user manages their own todos mapped by a unique todoId.
contract TodoList {
    /// @notice Represents a single Todo item
    /// @param title The title of the todo
    /// @param description The detailed description of the todo
    struct Todo {
        string title;
        string description;
    }

    /// @dev Stores todo details for each user by todoId
    mapping(address => mapping(uint256 => Todo)) internal addressToTodos;

    /// @dev Stores list of todoIds created by each user
    mapping(address => uint256[]) internal addressToTodoIds;

    /// @dev Tracks existence of a todo for a given user and todoId
    mapping(address => mapping(uint256 => bool)) internal exists;

    /// @notice Adds a new Todo for the caller
    /// @dev Does nothing if a todo with the same ID already exists
    /// @param _todoId Unique identifier for the todo
    /// @param _title Title of the todo item
    /// @param _description Description of the todo item
    function addToDo(
        uint256 _todoId,
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

    /// @notice Returns a specific Todo by its ID for the caller
    /// @dev Reverts if the todo does not exist
    /// @param _todoId The unique identifier of the todo
    /// @return The Todo struct containing title and description
    function getTodoWithId(uint256 _todoId) public view returns (Todo memory) {
        address userAddress = msg.sender;

        if (!exists[userAddress][_todoId]) {
            revert TodoNotFound(_todoId);
        }

        return addressToTodos[userAddress][_todoId];
    }

    /// @notice Returns all Todos created by the caller
    /// @dev Iterates through stored todoIds and builds arrays in memory
    /// @return todoIds Array of todo IDs
    /// @return titles Array of todo titles
    /// @return descriptions Array of todo descriptions
    function getAllTodos()
        public
        view
        returns (
            uint256[] memory todoIds,
            string[] memory titles,
            string[] memory descriptions
        )
    {
        address userAddress = msg.sender;
        todoIds = addressToTodoIds[userAddress];

        titles = new string[](todoIds.length);
        descriptions = new string[](todoIds.length);

        for (uint256 i = 0; i < todoIds.length; ++i) {
            Todo memory todo = addressToTodos[userAddress][todoIds[i]];
            titles[i] = todo.title;
            descriptions[i] = todo.description;
        }
    }

    /// @notice Removes a todoId from the caller's list
    /// @dev Internal helper function to remove a todoId from user's list
    /// @param _todoId The ID of the todo to remove
    /// @return True if removal was successful
    function removeTodoId(uint256 _todoId) internal returns (bool) {
        address userAddress = msg.sender;
        uint256[] storage todoIds = addressToTodoIds[userAddress];

        bool todoFound = false;

        for (uint256 i = 0; i < todoIds.length - 1; ++i) {
            if (todoIds[i] == _todoId || todoFound) {
                todoFound = true;
                todoIds[i] = todoIds[i + 1];
            }
        }

        if (todoIds.length > 0 && todoIds[todoIds.length - 1] == _todoId) {
            todoIds.pop();
            todoFound = true;
        }

        return todoFound;
    }

    /// @notice Removes a specific Todo of the caller
    /// @dev Deletes the todo data and removes its ID from storage
    /// @param _todoId The unique identifier of the todo to remove
    function removeTodo(uint256 _todoId) public {
        address userAddress = msg.sender;

        if (!exists[userAddress][_todoId]) {
            revert TodoNotFound(_todoId);
        }

        delete addressToTodos[userAddress][_todoId];
        removeTodoId(_todoId);
        exists[userAddress][_todoId] = false;
    }
}

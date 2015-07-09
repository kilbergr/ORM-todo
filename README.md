#ORM Todo App
Write a command line based todo application that allows the user to create, read, update, and delete todos.

##The user should be presented with a prompt similar to the following:

* Welcome to the todo app, what would you like to do?
* n - make a new todo
* l - list all todos
* u [id] - update a todo with a given id
* d [id] - delete a todo with a given id, if no id is provided, all todos will be deleted
* q - quit the application

The user can select from the options listed. And present the user with the appropriate prompts after he makes his selection.

##Requirements

* Make an ORM-like todo object for your command line app.
* Most of your logic should be in your ORM Todo class. You will need a todo class that allows you to create, read, update and delete objects from your database.
* The data should persist to the database. If I use the app, create a new todo, quit, and then start the app again. The todos I created should still be there.
* When you list all of the todos, be sure to print the ids of the todos as well, otherwise the user would not be able to delete or update.
* Implement an all class method that gets all the todos
* Implement a delete_all class method that deletes all the todos in the table.

##Bonus

* Add a column in the database to keep track of the todo if it was completed.
* Allow the user to mark todos as completed.
* Allow the user to see all todos or only see incomplete todos.
### MVC Notes:
- MVC stands for model view controller, and it is a design pattern that separates out different concerns of the application into different files.
1. The user makes a request to the backend. This is fed to the controller.
2. The controller interacts with the model, which gets the needed information from the database. The objects representing data in the database are returned to the controller.
3. The data is passed to the view, which formats the dynamic data into nice HTML. The finalized view is passed back to the controller.
4. The controller gives the response to the user.



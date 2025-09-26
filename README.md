# Tutorial Backend Simple with Node

This application allows users to create and maintain a list of tutorials that can have multiple lessons within. Please visit  https://github.com/OC-ComputerScience/tutorial-frontend-vue3-simple for the Vue 3 frontend repository.
 
#### Please note:
- You will need to create a database and be able to run it locally.

## Project Setup
1. Clone the project into your **XAMPP/xamppfiles/htdocs** directory.
```
git clone https://github.com/OC-ComputerScience/tutorial-backend-simple.git
```

2. Install the project.
```
npm install
```

3. Configure **Apache** to point to **Node** for API requests.
    - We recommend using XAMPP to serve this project.
    - In XAMPP, find the **Edit/Configure** button for **Apache**.
    - Edit the **conf** file, labeled **httpd.conf**. 
    - It may warn you when opening it but open it anyway.
    - Add the following line as the **last line**:
    
    ```
    ProxyPass /tutorial-simple http://localhost:3101/tutorial-simple 
    ```
    
    - Save the file.
    - **Restart Apache** and exit XAMPP.

4. Make a local **tutorial** database.
    - Create a schema/database. Set the name in the .env file
    - The sequelize in this project will make all the tables for you.

5. Add a local **.env** file a make sure that the **database** variables are correct.
    - Copy the example environment file: `cp .env.example .env`
    - Edit the .env file with your settings:
    - DB_HOST = 'localhost' or '127.0.0.1'
    - DB_PW = '**your-local-database-password**' (leave empty for default)
    - DB_USER = '**your-local-database-username**' (usually "root")
    - DB_NAME = '**your-local-database-name**' (e.g., 'testdb')
    - DB_PORT = '3306' (default MySQL) or '3307' (for XAMPP users)
    - PORT = '8080' (backend server port)

6. Compile and run the project locally.
```
npm run start
```

7. Test your project.

```
8. For deployment to AWS set up repository secrets for the values in the .env for the AWS configuration.
    - DB_HOST = 'localhost'
    - DB_PW = '**your-database-password**'
    - DB_USER = '**your-database-username**' 
    - DB_NAME = '**your-database-name**'
    - DB_PORT = '3306' (or your MySQL port)
    - PORT = '**port for backend**'
    - SERVER_SSH_KEY = '**SSH key from the PEM file for AWS EC2 instance**'


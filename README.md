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
    - DB_HOST = 'localhost'
    - DB_PW = '**your-local-database-password**'
    - DB_USER = '**your-local-database-username**' (usually "root")
    - DB_NAME = '**your-local-database-name**'
    - PORT = '3101'

6. Compile and run the project locally.
```
npm run start
```

7. Test your project.

```
8. For deployment to AWS set up repository secrects for the values in the .env for the AWS configurtation.
    - DB_HOST = 'localhost'
    - DB_PW = '**your-local-database-password**'
    - DB_USER = '**your-local-database-username**' 
    - DB_NAME = '**your-local-database-name**'
    - PORT = '**port for backend **'
    - SERVER_SSH_KEY = '** SSH key from the PEM file for AWS EC2 instance **'


# Basic App (Ruby On Rails version) - basic_app
Basic wireframe for an application. Can be made into anything really. Using this as a demo for resumes. Has user authentication with profiles and user images.

Ruby On Rails Front-End/Back-End for https://github.com/brianhodges/basic_app_ios

Contact me with bugs, tips, criticism at: hodgesbn@yahoo.com

# Setup
1) *install PostgreSQL and match database credentials to that of database.yml*

2) *rake db:migrate*

3) *rake db:seed*

4) *create user through UI and update them in USERS table (using SQL at Postgres level) to match admin in ROLES Table*

    ## Ex.

    Roles (Table)
    
    id|role
    ---|---
    100|  Admin
    200|  User

    Users (Table)
    
    id|email|role_id
    ---|---|---
    777| user@example.com|200  (default)

      ```sql
      UPDATE USERS SET ROLE_ID = 100 WHERE ID = 777;
      ```

5) *run local rack or thin server*

6) *have fun*


## App runs on:
Rails 4.2.1

Ruby 2.2.1

jQuery 1.12.4

AngularJS 1.6.1

Bootstrap 3.3.7

PostgreSQL 9.2.1

Font Awesome 4.7.0

HTML/CSS



Note: Users created in the iOS (Swift/Xcode) implementation can also authenticate into the ROR site with the same credentials. Both use https://basic-app.herokuapp.com/ as the back-end.

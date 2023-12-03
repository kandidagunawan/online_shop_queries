# Online Shop Database Queries

## Description
This repository contains a collection of MariaDB SQL queries designed for managing an online shop's database. These queries range from basic data retrieval to more complex data manipulation tasks.

## Requirements
MariaDB

## How to run
1. Clone this repository
2. Run MariaDB using this command
   ```
   mariadb -u {username} -p
   ```
4. Create new database using this command
   ```
   CREATE DATABASE {database_name}
   ```
6. Exit MariaDB
7. Restore database from file external (online_shop.sql) using this command
   ```
   mysql -u {username} -p {database_name} < {external_file_name}.sql
   ```
8. Re-run MariaDB and use the same database you have created before
9. Try to use SQL query I have written

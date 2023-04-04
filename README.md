# CE-Phoenix Docker

# Requirements

1. docker and docker-compose
2. unzip
3. wget
4. awk

# How to run

1. Create `.env` file

```
DB_PORT=3306
MYSQL_ROOT_PASSWORD=my_secret_password
MYSQL_DATABASE=app_db
MYSQL_USER=db_user
MYSQL_PASSWORD=db_user_pass
PMA_HOST=database
PMA_PORT=3306
PMA_ACCESS_PORT=8080
PMA_ARBITRARY=1
PORT=9876
```


2. Run `./phoenix.sh -s` ( if not work run `chmod +x ./phoenix.sh` )
3. Open browser on `http://localhost:9876` or in the `PORT` specified in `.env` file
4. Start installation procedure

# Setup database connection

- Database server: `database` (it's the docker service name)
- Username: watch `.env` file
- Password: watch `.env` file
- Database name: watch `.env` file

# Configure the store parameters as you prefer

# Rebase Challenge 2022

Ruby API for listing medical exams from a CSV file.
The challenge description can be read [here](instructions.md).

## Tech Stack

* Docker
* Ruby
* Rspec
* Sinatra
* Redis
* Sidekiq

## Running

```bash
$ git clone git@github.com:davide-almeida/rebase-challenge-2022.git
$ cd rebase-challenge-2022
$ bash run
$ ruby server.rb
```

## Routes and endpoints available

```
localhost:3535 -> Sidekiq panel
localhost:3000/tests -> (GET) List all tests
localhost:3000/tests/:token -> (GET) Find test by token
localhost:3000/import -> (POST) Send a CSV file. The input-field name is 'csv_file'.
```
Example post with Postman:

![image](https://user-images.githubusercontent.com/85287720/179868493-26dc7582-e542-4f1f-9455-335d66fcb81e.png)

## Commands available
### App:
```
ruby server.rb -> Start app
bash help -> Commands list
```

### Database:
```
rake all -> Remove tables, create new tables e populate database.
rake database:db_drop -> Remove tables
rake database:db_client -> Create Clients table
rake database:db_doctor -> Create Doctors table
rake database:db_test -> Create Tests table
rake seed_database:db_insert -> Populate database
```
## API
[Documentation](api.md)

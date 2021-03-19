# Werkspot DE Challenge

This project solves the Werkspot Challenge.

# Stack

This projects uses docker-compose to run two Docker images:

- PostgreSQL: This container host an instance of the postgres database to store all the information.
- Python with DBT: This container is in charge to load and process all the information.

# Steps to run it

1. Clone/Fork/Download the repository.
2. Make sure you have `Docker` and `docker-compose`.
3. Execute the PostgreSQL container:
```bash
docker-compose up -d postgres
```
4. Execute the script to ingest and generate the models:
```bash
docker-compose run dev sh bin/provision.sh
```

# How it works?

The `bin/provision.sh` script follow this steps:

1. Pre-process the CSV file, replacing `;` with `,` and sending the output to the `data` folder.
2. The data is inserted into the `raw` schema in the table `events_logs`, using the command `dbt seed`.
3. Two tables are generated, using the command `dbt run`:
- `public.events`: This solves the first question.
- `public.availability_snapshot`: This solves the second question.


# How can I visualize the data?

The PostgreSQL container is exposed in the port 5432, so you can connect to it from your local using the following credentials:
```
host: localhost
port: 5432
user: fake_user
password: fake_password
db: events
```

# Where does the code live?

- [Python script](scripts/pre_processing.py)
- [SQL queries](models/events)

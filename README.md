# Platform API

The Platform API is a robust backend service built with Ruby on Rails. It provides support for a number of crucial activities, such as managing users, handling orders, conducting payments, and more. Below, we provide a brief introduction to the architecture and usage of this API.

## Project Structure

The Platform API follows a standard Rails project structure. Here are some key directories and the role they play:

- `app/`: This contains several directories, each responsible for a specific segment of the application. It includes MVC-based components (Models, Views, Controllers), along with Helpers, Jobs, Channels, Entities, and other miscellaneous files.
- `bin/`: Contains binaries for Rails, Rake, Setup, and others.
- `config/`: Holds all the configuration file of Rails application including, database, routes, locales, and various initializers.
- `db/`: Contains the database schema and the migrations to update it.
- `lib/`: Includes additional custom classes or modules to support the application.
- `public/`: Stores static files and compiled assets.
- `test/`: All the test code and associated fixtures goes into this directory.
- `vendor/`: Contains third-party code.

## Usage 

The following instructions cover how to set up and interact with the Platform API on your local machine for development and testing purposes.

### Prerequisites 

Ensure you have the following installed requirement on your machine:

- Ruby (version specified in `.ruby-version` file)
- Bundler
- Rails (version specified in `Gemfile`)
- Database system (postgis)
- Storage system with (aws provider like minio)
- Queue system with (rabbitmq)
- Vault encryption system
- Google Credentials

Explained of that requirement is :
- Ruby

Ruby version on this project using version `3.0.5`, following installation step on [ruby installation step](https://gorails.com/setup/ubuntu/22.04)

- Bundler

Bundle version to running project using version `2.2.33`

- Rails

Rails version itself on this project using version `7.0.6`, following installation steps on [rails installation step](https://gorails.com/setup/ubuntu/22.04)

- Database

Database system on this project using `postgis` beacuse that is requirement to using geometry location system with gem postgis adapter can using any version of postgis, for installation postgis you can run 

! when using docker and docker-compose !
```sh
$ docker-compose up -Vd postgis
```
that command will be running script `.yaml` if using docker or follow installation step on [postgis documentation](https://postgis.net/documentation/getting_started/)


- Storage system

Storage system supported with `aws provider` like minio, aws clound storage, ensuring completed configuration for storage in `config/initializers/carierwave.rb`
about the configuration in `carierwave.rb` is

```rb
CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID",""),
      aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY",""),
      region: ENV.fetch("AWS_REGION", "es-west-1"),
      endpoint: ENV.fetch("AWS_ENDPOINT", ""),
      path_style: ENV.fetch("AWS_PATH_SYLE", true)
    }
    config.fog_directory = ENV.fetch("BUCKET_NAME", "")
end
```

in variable of config environment set on file `.env` whit environment variable is
```
AWS_SIGNATUR_VERSION=<aws_provider_verion>
AWS_ACCESS_KEY_ID=<aws_secret_id>
AWS_SECRET_ACCESS_KEY=<aws_secret_key>
AWS_REGION=<aws_region>
AWS_ENDPOINT=<aws_endpoint>
AWS_PATH_SYLE=<aws_path_style,. true/false>
BUCKET_NAME=<aws_bucket_name>
```

for configuration storage system you can install minio example of storage system in this project by running

! when using docker and docker-compose !
```sh
$ docker-compose up -Vd minio
```
or you can following installation step for minio in (minio documentation)[https://min.io/docs/minio/container/operations/installation.html]

- Queue System

Queue system in this project using rabbitmq, for installation step of rabbitmq you can running command

! when using docker and docker-compose !
```sh
$ docker-compose up -Vd rabbitmq
```

or you can follow the installation step on (rabbitmq installation)[https://www.rabbitmq.com/download.html]

about the configuration of rabbitmq it will be setup on `config/rabbitmq_channel.yml`, for the exchange, queue, and routing_key that all has been declared on that file

configuration rabbitmq will running base on initialization on `config/initializers/rabbitmq.rb` that will generate all exchange, queue, and routing_key

configuration list of rabbitmq is 
```rb
RABBITMQ_CONNECTION = Bunny.new(
  host: ENV.fetch("RABBITMQ_HOST"),
  port: ENV.fetch("RABBITMQ_PORT"),
  user: ENV.fetch("RABBITMQ_USERNAME"),
  pass: ENV.fetch("RABBITMQ_PASSWORD")
)
```
and set the enirontment variable on `.env` with following the this script:
```bash
RABBITMQ_HOST=<rabbitmq_host>
RABBITMQ_PORT=<rabbitmq_port>
RABBITMQ_USERNAME=<rabbitmq_username>
RABBITMQ_PASSWORD=<rabbitmq_password>
```

and following channel configuration of rabbitmq like base on `config/rabbitmq_channel.yml`

- Vault system

installation `vault` you can run command

! when using docker and docker-compose !

`docker-compose up -Vd vault`

or you can following installation vault in [vault installation](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install)

when vault is instaleld in your machine that vault will be empty and need first configuration of vault with using command

```sh
$ vault operator init -key-shares=6 -key-threshold=3
```

that will be init vault server key with return is :
```bash
Unseal Key 1: s15eSog8DYtHW4xD2uDjaTo1bN90I5CqiOWAtfl4Q/CB
Unseal Key 2: Vq7wiopA+QBNs8UJyhTQjK1SrXd1+Qzm9+zJ9UykjBHu
Unseal Key 3: 0tG69C5QMsmfw9a3+sRMhMNBcStR6ZTPbMjJOfXH8R9h
Unseal Key 4: nXsmSN4CYq6vyP0h0VmlvVw15H5QODrWPHAwCB500zTk
Unseal Key 5: ycw9LxC5ry9rs9VfYFj9NZuHb4yH9u5GGB3xQIcKj7x6
Unseal Key 6: LDyT7xLFW6RhW5wVcKzO0AzgriSGLHIKZxS4ADLWQF0V

Initial Root Token: s.03Q4wNG86VkoiUfJbiE3XMsG
```

that key will only show one time after initialization with 6 shared unseal key and 3 key thershold.

when vault is locked you can unlock with following command with `vault operator`

```sh
$ vault operator unseal
```

in 3 time with 3 different of unseal key because for first initialization of vault server using 3 key thershold to unlock and 6 key to unseal,
vault server it self is seal or locked when your machine is down or off, and only need 3/6 unseal key to unseal or unlocked that vault server.

configuration vault it self is set on `config/vault.rb`
```rb
Vault::Rails.configure do |config|
  config.enabled = Rails.env.production? || Rails.env.development?
  config.address = ENV.fetch("VAULT_ADDRESS")
  config.token = ENV.fetch("VAULT_TOKEN")
  config.ssl_verify = false
  config.timeout = 60
end
```

for configuration environtment in file `.env` will set on varible :
```bash
VAULT_ADDRESS=<vault_address>
VAULT_TOKEN=<vault_token>
```

- Google Credentils

about the google credentials is configuration
```bash
GOOGLE_CLIENT_ID=<client_id>
GOOGLE_CLIENT_SECRET=<client_secret>
```

configuration of google credentials you can following the step on (google credentials)[https://developers.google.com/workspace/guides/create-credentials] copy your `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` and set to file `.env` in project

the google credentials is using for `auth/google` to access the endpoint

### information
when all requirement is completed the apps will be running with no warning alert
   when one of requirement uncompleted apps will be return warning missing or not connected to service like rabbitmq, vault server, postgis, and 

### Running Project ENVIRONMENT
- development
   set `RAILS_ENV` on file `.env` to development when running in development mode on local machine

- production
   set `RAILS_ENV` on file `.env` to production when running in production mode on production server or using docker for production concept

### Setting Up

1. Clone the repository onto your local machine:

   ```sh
   $ git clone <repo_url>
   ```

2. Navigate into the project directory:

   ```sh
   $ cd platform-api
   ```

3. Install the project dependencies:

   ```sh
   $ bundle install
   ```

4. Copy .env.example into .env:

   ```sh
   $ cp .env.exmaple .env
   ```

5. Running the prerequisites tools:

   ```sh
   $ docker-compose up -d
   ```

6. Fill .env with the actual data.

7. Set up the database:

   ```sh
   $ rake db:setup
   ```

8. Start the server:

   ```sh
   $ rails s -p 3000
   ```

Now, you can access the API at `http://localhost:3000`.

### Docker Build

The included Dockerfile allows you to build a Docker image of the application:

```
$ docker build -t your-docker-username/api-project .
```

Then run the image:

```
$ docker run -p 3000:3000 -d your-docker-username/api-project
```

The server should now be running on `http://localhost:3000`.

Remember to change "your-docker-username" with your Docker username.

### Running Tests

This project includes various unit and system tests. To run all the tests, navigate to the project's root directory and run:

   ```sh
   $ rails test
   ```

### API Features 

The Platform API includes the following main features:

- User Management: `app/controllers/api/v1/users_controller.rb` handles user creation, profile updates, deletion, and other user-specific actions.
- Order Management: `app/controllers/api/v1/orders_controller.rb` has the endpoints related to orders, their management and status updates.
- Therapist Management: `app/controllers/api/v1/therapists_controller.rb` manages the therapist profiles and actions related to them.
- Service Management: `app/controllers/api/v1/services_controller.rb` deals with service details, like creating new services, updating, or deleting existing ones.
- Payment Management: `app/controllers/api/v1/payments_controller.rb` handles operation related to payments.
- Session Management: `app/controllers/api/v1/sessions_controller.rb` manages user authentication.
  
### API Endpoints

Each file in the `app/controller/` directory corresponds to a different set of API endpoints. In most cases, these include `index`, `show`, `create`, `update`, and `delete` actions.

Thus, depending on the controller, endpoints will take the form of:

- `GET /<controller>`: Fetch a list of all resources of this type.
- `POST /<controller>`: Create a new resource of this type.
- `GET /<controller>/:id`: Fetch details of a specific resource. 
- `PATCH/PUT /<controller>/:id`: Update the details of a specific resource.
- `DELETE /<controller>/:id`: Delete a specific resource.

[Postman](https://www.getpostman.com/), or any other API testing tool, can be used to simulate client requests to these endpoints.

## Further Help

For further queries about the Platform API, you can refer to the official [Rails Documentation](https://guides.rubyonrails.org/) or raise an issue on the project's GitHub repository.

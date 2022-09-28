# Speed Leasing - Lease Origination System (LOS)
![GitHub contributors](https://img.shields.io/badge/contributors-23-yellow)

The LOS is an application that connects potential buyers of motorcycles with dealers and financing.

For a quick run-through of what a Lease is, how it works, and the terminology therein, please review:
* [leaseguide.com/articles/carleasedeals](https://www.leaseguide.com/articles/carleasedeals/)
* [youtube.com/watch?v=RVNsLlBNufs](https://www.youtube.com/watch?v=RVNsLlBNufs)

## Installation and Usage

### Prerequisites

Before you begin, ensure you have met the following requirements:
* You have installed Docker
* You have installed Docker Compose
* You have access to `admin-portal` repository

#### Windows Users ####
We highly recommend running Docker from WSL (Windows Subsystem for Linux) to avoid performance issues. Follow the links below for additional information.
1. [Windows Subsystem for Linux Installation Guide for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
1. [Add a new SSH key to your GitHub account](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
1. Install Docker and Docker Desktop on your Windows machine
1. [Activate the WSL integration](https://docs.docker.com/docker-for-windows/wsl/)
1. On your WSL, run `sudo service docker start`
1. If your IDE of choice is Sublime Text 3, then:
    1. Install Sublime Text 3 in Windows
    1. In your WSL instance, set an alias to Sublime: `alias subl='/mnt/c/Program\ Files/Sublime\ Text\ 3/subl.exe'`
    1. [Access the files directly from Windows 10 Sublime instance](https://stackoverflow.com/a/61258641/1575022)
* [How to add git branch name to shell prompt in Ubuntu](https://dev.to/sonyarianto/how-to-add-git-branch-name-to-shell-prompt-in-ubuntu-1gdj)

### Installation

1. Clone this repository
1. If using WSL:    
    1. Run `sudo chown -R yourusername:yourusername slc-los/`
1. Make a copy of the `.env.sample` file, saving it as `.env`
1. Run `docker-compose build`
1. Run `docker-compose run --rm los-rails bundle install`
1. Log into the container: `docker exec -it slc-los_los-db_1 bash`
1. Install curl: `apt-get update && apt install -y curl`
1. Install the Heroku CLI: `curl https://cli-assets.heroku.com/install.sh | sh`
1. Assume the postgres role: `su postgres`
1. Create the root user and a role for the LOS database:
    1. `psql`
    1. `CREATE USER root SUPERUSER;`
    1. `ALTER USER root WITH PASSWORD 'local123!';`  
    1. `\q`
1. Log in to the CLI: `heroku login -i`
1. Restore a copy of the Staging database to the container: `heroku pg:pull HEROKU_POSTGRESQL_PURPLE_URL speed_leasing_development --app slc-los-staging`
1. `exit` to exit the assumed `postgres` role
1. `exit` again to exit the container

### Usage

\*Note: The first time you follow the Usage instructions below, you will run into an error. Refer to the [Troubleshooting](#troubleshooting) section.

1. Run `docker-compose up`
1. Follow the instructions in the `admin-portal` repository to start its Docker container and run the Admin Portal
1. Access Admin Portal in [http://localhost:3000/admins/login](http://localhost:3000/admins/login)
1. Access Dealer Portal in [http://localhost:3000/dealers/login](http://localhost:3000/dealers/login)

### Troubleshooting

* If you receive similar logs (from docker) below, run the following command: `sudo chown -R 5050:5050 ./pgadmin_data`

```
WARNING: Failed to set ACL on the directory containing the configuration database:
           [Errno 1] Operation not permitted: '/var/lib/pgadmin'
HINT   : You may need to manually set the permissions on
         /var/lib/pgadmin to allow pgadmin to write to it.
ERROR  : Failed to create the directory /var/lib/pgadmin/sessions:
           [Errno 13] Permission denied: '/var/lib/pgadmin/sessions'
HINT   : Create the directory /var/lib/pgadmin/sessions, ensure it is writeable by
         'pgadmin', and try again, or, create a config_local.py file
         and override the SESSION_DB_PATH setting per
         https://www.pgadmin.org/docs/pgadmin4/6.2/config_py.html
```

* If `pdftk` for some reason is not accessible in rails container, you can manually install it with the following:
  - Follow the instructions in [Accessing the Rails Container](#accessing-the-rails-container)
  - Run the following:
    ```bash
    # Install from archive
    sudo add-apt-repository ppa:malteworld/ppa
    sudo apt update
    sudo apt-get install pdftk
    # Test
    pdftk --version
    ```

### ENV Configuration

See [docs/ENV_CONFIGURATION.md](docs/ENV_CONFIGURATION.md)

## Development

### New Gems

Any time you make changes to Gemfile or Gemfile.lock, you'll need to run bundle install. Follow these steps:

1. If the container is running, first use `Ctrl + C` to close the container
1. Next, run `docker-compose run --rm los-rails bundle install`
1. When you're done, follow the instructions in [Usage](#usage) to use the LOS

### Documentating the API

1. Follow the instructions in [Accessing the Rails Container](#accessing-the-rails-container)
1. Create an integration spec (e.g., `rails g rspec:swagger Api::ModelGroupsController`)
1. Open and edit your spec (e.g., `/spec/requests/api/model_groups_spec.rb`)
1. Regenerate the Swagger JSON file: `rake rswag:specs:swaggerize`
1. Optionally, check your markup in `/swagger/v1/swagger.yaml`
1. View your API docs at [http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html)

### Migrations

1. Follow the instructions in [Accessing the Rails Container](#accessing-the-rails-container)
1. Run `bundle exec rake db:migrate`
1. `exit` to exit the container

### Scaffolding

1. Follow the instructions in [Accessing the Rails Container](#accessing-the-rails-container)
1. Scaffold as normal

### Testing

1. Follow the instructions in [Accessing the Rails Container](#accessing-the-rails-container)
1. The RSpec test suite has model, controller, and feature level specs defined
    1. Run `bundle exec rspec spec`
    1. Optionally, you can view the coverage report on your local machine in the `coverage` directory
1. The Cucumber test suite has higher level integration and feature level tests defined. The Calculators are tested here as well due to Cucumber's Scenario Outline feature.
    1. Run `bundle exec cucumber`
        > **NOTE** This test suite is deprecated. Tests should be moved to RSpec whenever you work on a feature tied to a Cucumber test.

### Accessing the Rails Container

1. Open a new Bash window
1. Make sure the `los-rails` container is running (execute `docker ps` to view a list of running containers)
1. Access the container in a separate console window: `docker exec -it slc-los_los-rails_1 bash`

### Accessing the Database Container

1. Open a new Bash window
1. Access the container in a separate console window: `docker exec -it slc-los_los-db_1 bash`

### Refreshing the Database

1. Stop all running containers with `docker-compose down`
1. Start just the database container: `docker-compose up -d los-db`
1. Follow the instructions in [Accessing the Database Container](#accessing-the-database-container)
1. Assume the postgres role: `su postgres`
1. Drop the local database:
    1. `psql`
    1. `DROP DATABASE speed_leasing_development;`
    1. `\q`
1. Log in to the CLI: `heroku login -i`
1. Run the full `heroku pg:pull` command listed in the [Installation](#installation) section
1. `exit` to exit the assumed role
1. `exit` again to exit the container

### Accessing pgAdmin

You may want to access `pgAdmin` to interact with the database through a GUI. Follow the steps below.

1. If you haven't already done so, start the containers with `docker-compose up`
1. To access `pgAdmin`, visit [http://localhost:18080/](http://localhost:18080/)
    1. Username: The `PGADMIN_DEFAULT_EMAIL` value in `docker-compose.yml`
    1. Password: The `PGADMIN_DEFAULT_PASSWORD` value in `docker-compose.yml`
1. Add/register a new server using the following connection information:
    1. Host Name/Address: `los-db`
    1. Port: `5432`
    1. Username: `POSTGRES_USER` from `docker-compose.yml`
    1. Password: `POSTGRES_PASSWORD` from `docker-compose.yml`
    1. Check the "Save password?" checkbox

### Docker Maintenance

1. If you need to remove **all** Docker containers and images:
    1. Stop and remove resources with `docker-compose down`
    1. Run `docker system prune -a`
1. Add the `--volumes` flag to prune volumes as well.

    > **WARNING** This will remove the volume containing your LOS database!

### Installation without Docker

1. Refer to `Dockerfile` for a list of packages to install on a Linux system
1. Comment out the following gems in the `group :development do` section of the Gemfile:
    1. hirb
    1. capybara-webkit
    1. chromedriver-helper
    1. rspec-sidekiq

## Contributors

Thanks to the following people who have contributed to this project:

* [@adam-szczombrowski](https://github.com/adam-szczombrowski)
* [@ahdelgado1](https://github.com/ahdelgado1)
* [@ali-hassan-mirzaa](https://github.com/ali-hassan-mirzaa)
* [@attiq](https://github.com/attiq)
* [@brossetti1](https://github.com/brossetti1)
* [@danielricecodes](https://github.com/danielricecodes)
* [@gitreuben](https://github.com/gitreuben)
* [@HamzaShafiq](https://github.com/HamzaShafiq)
* [@kalil1](https://github.com/kalil1)
* [@josetsky](https://github.com/josetsky)
* [@kapilchoudhary](https://github.com/kapilchoudhary)
* [@kumarkekse](https://github.com/kumarkekse)
* [@markblasdls](https://github.com/markblasdls)
* [@mohdsameer](https://github.com/mohdsameer)
* [@nrowegt](https://github.com/nrowegt)
* [@paulmiller3000](https://github.com/paulmiller3000)
* [@rajprasadROR](https://github.com/rajprasadROR)
* [@rindek](https://github.com/rindek)
* [@sylv3rblade](https://github.com/sylv3rblade)
* [@talhajunaid63](https://github.com/talhajunaid63)
* [@vpibano](https://github.com/vpibano)
* [@tahiry-dev](https://github.com/tahiry-dev)
* [@paula4230](https://github.com/paula4230)

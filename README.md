# Pokemon

Very light server with just one endpoint to retrieve a pokemon shakespearean description by name.

## Install and start with docker

Install docker following the official instruction for your system https://docs.docker.com/get-docker/

Enter the root directory of the project.

Build the image with the command:
```
docker build -t pokemon:1.0 .
```

Run the container and the application with the command:
```
docker run --publish 5000:5000 --detach --name pokemon -t pokemon:1.0
```

To stop the container and the applicaton run the command:
```
docker stop pokemon
```

To follow logs from the application run the command:
```
docker logs -f pokemon
```

## Install and start without docker
Install the tool manager `asdf` following the official guide https://asdf-vm.com/#/core-manage-asdf-vm

Install erlang and elixir latest versions following the guide https://github.com/asdf-vm/asdf-elixir

Enter the root directory of the project.

Get dependencies with the command:
```
mix deps.get
```

Start the server with the command:
```
mix run --no-halt
```

## Access the api
After installing and starting the application with one of the previous strategies,
access the API from the host machine at http://localhost:5000/pokemon/pikachu with `httpie` 
or any other CLI tool or from your browser.

## Run tests
To run unit tests execute the command:
```
mix test
```

To run also integration tests execute the command:
```
mix test --include integration_test
```
Running integration tests many times could incur in failures due to rate limiting issues.

To run tests in the container, run a shell into it with the command:
```
docker exec -it pokemon bash
```
Then run the previous commands.

default: usage

# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows batch file
    SCRIPT := download-dataset.bat
	ECHO = echo
	OLLAMA_MODEL := $(shell findstr /B "OLLAMA_MODEL=" .env | findstr /V /C:;)
	MODEL_NAME := $(subst OLLAMA_MODEL=,,$(OLLAMA_MODEL))
else
    # Unix/Linux shell script
    SCRIPT := ./download-dataset.sh
	ECHO = echo
	MODEL_NAME := $(shell grep "^OLLAMA_MODEL=" .env | cut -d "=" -f 2-)
endif

all: 
	make download
	make dk_start

download:
	$(SCRIPT)

dk_start:
	docker network create my_external_network
	docker run -d --network=my_external_network -v ollama:/root/.ollama  -p 11434:11434 --name ollama ollama/ollama
	docker exec ollama ollama pull $(MODEL_NAME)
	docker-compose up --build -d
dk_stop:
	docker-compose down --volumes --remove-orphans --rmi all
	docker stop ollama
	docker rm ollama
	docker network rm my_external_network





download-extras:
	$(SCRIPT)

usage:
	@$(ECHO) Usage
	@$(ECHO) 	make dk_start   - Start the docker containers
	@$(ECHO) 	make dk_stop    - Stop the docker containers
	@$(ECHO) 	make download   - Download dataset from web
	@$(ECHO) 	make all        - Download dataset from web and Start the docker containers


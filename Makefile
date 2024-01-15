default: usage

all: 
	make download
	make dk_start

download:
	$(SCRIPT)

dk_start:
	docker-compose up --build -d
dk_stop:
	docker-compose down --volumes --remove-orphans --rmi all


# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows batch file
    SCRIPT := download-dataset.bat
	ECHO = echo
else
    # Unix/Linux shell script
    SCRIPT := ./download-dataset.sh
	ECHO = echo
endif

download-extras:
	$(SCRIPT)

usage:
	@$(ECHO) Usage
	@$(ECHO) 	make dk_start   - Start the docker containers
	@$(ECHO) 	make dk_stop    - Stop the docker containers
	@$(ECHO) 	make download   - Download dataset from web
	@$(ECHO) 	make all        - Download dataset from web and Start the docker containers


#!/bin/bash

if ! [ -f ./dataset/crime_data.csv ]
then
	echo -e "Downloading Los Angeles crime data from data.gov"
	curl -s -o ./dataset/csv/crime_data.csv https://data.lacity.org/api/views/2nrs-mtv8/rows.csv\?accessType\=DOWNLOAD

	if [ $? -eq 0 ]
	then
		echo "Download complete"
        python3 reformat_data.py
	else
		echo "Download failed"
		exit 1
	fi
else
	echo -e "crime data already exists"
fi
#!/bin/bash

first=$(date)
temp=$(date --date="+1 second" +%s)
now=$(date +%s)
while [ "$now" -lt "$temp" ]; do
	now=$(date +%s)	
done

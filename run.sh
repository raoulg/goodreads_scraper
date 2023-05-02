#!/bin/bash
echo "Please enter an ID:"
read id

export $(cat ENV.txt | xargs) && julia --project=backend -e 'include("backend/scrape.jl"); main("'"$id"'")'


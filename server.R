# Load used libraries
library(plumber)
library(jsonlite)
library(aqp)
library(sp)
library(lattice)
library(cluster)
library(sharpshootR)

source('parser.R')

# Generate the API
server <- plumb('api.R')

# Start the server on $RAPI_PORT
number = as.numeric(Sys.getenv('RAPI_PORT'))
server$run(port=number)

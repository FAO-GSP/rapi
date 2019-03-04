# Load used libraries
library(plumber)
library(jsonlite)
library(aqp)
library(sp)
library(lattice)
library(cluster)
library(sharpshootR)

# Load parser from JSON to AQP formats
source('parser.R')

# Generate API
server <- plumb('api.R')

# Start server on $RAPI_PORT
number = as.numeric(Sys.getenv('RAPI_PORT'))
server$run(port=number)

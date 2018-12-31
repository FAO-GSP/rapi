# Load used libraries
library(plumber)
library(jsonlite)

# Generate the API
server <- plumb('api.R')

# Start the server on $RAPI_PORT
number = as.numeric(Sys.getenv('RAPI_PORT'))
server$run(port=number)

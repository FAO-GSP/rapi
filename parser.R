# Parser from JSON to AQP objects

jsonToAqp <- function(json){
  # Read GeoJSON as a list
  json <- fromJSON(json, flatten = TRUE)$features

  # Get site properties into a matrix and convert to data.frame
  sites <- cbind(json$properties.id,
                 json$properties.identifier,
                 do.call(rbind, json$geometry.coordinates),
                 json$properties.country_code)
  sites <- as.data.frame(sites)

  # Rename data.frame variables
  names(sites) <- c('profile_id', 'identifier', 'X', 'Y', 'country_code')

  # Bind one data.frame per profile into a big data.frame
  spc <- do.call(rbind, json$properties.layers)

  # Ensure we have a well formed object
  if(is.data.frame(spc)) {
    # Fix numeric variables loaded as strings
    spc[5:18] <- lapply(spc[5:18], as.numeric)

    # Convert layers data.frame to spc
    depths(spc) <- profile_id ~ top + bottom

    # Add site properties to spc
    site(spc) <- sites

    # Upgrade XY to spatial coordinates
    coordinates(spc) <- ~ X + Y

    return(spc)
  } else {
    stop('Soil profiles are empty!')
  }
}

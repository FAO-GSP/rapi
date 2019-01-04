jsonToAqp <- function(json){
  # read geojson as a list
  json <- fromJSON(json, flatten = TRUE)$features
  # get site properties into a matrix and convert to data.frame
  sites <- cbind(json$properties.id, json$properties.identifier, do.call(rbind,json$geometry.coordinates),
                 json$properties.country_code)
  sites <- as.data.frame(sites)
  # rename data.frame variables
  names(sites) <- c("profile_id", "identifier", "X", "Y", "country_code")
  # bind 1 data.frame per profile into a big data.frame
  spc <- do.call(rbind, json$properties.layers)
  # fix numeric variables loaded as strings
  spc[5:18] <- lapply(spc[5:18], as.numeric)
  # convert layers data.frame to spc
  depths(spc) <- profile_id ~ top + bottom
  # add site properties to spc
  site(spc) <- sites
  # upgrade XY to spatial coordinates
  coordinates(spc) <- ~ X + Y
  return(spc)
}
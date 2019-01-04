jsonToAqp <- function(json){
  json <- fromJSON(json, flatten = TRUE)$features
  sites <- cbind(json$properties.id, json$properties.identifier, do.call(rbind,json$geometry.coordinates),
                 json$properties.country_code)
  sites <- as.data.frame(sites)
  names(sites) <- c("profile_id", "identifier", "X", "Y", "country_code")
  spc <- do.call(rbind, json$properties.layers)
  depths(spc) <- profile_id ~ top + bottom
  site(spc) <- sites
  coordinates(spc) <- ~ X + Y
  return(spc)
}
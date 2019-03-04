# R API for SiSINTA

# Filters for preprocessing the request object.

#* Log some information about the incoming request.
#*
#* @filter logger
function(req){
  # Displays this info on standard output.
  cat(as.character(Sys.time()), "-",
    req$REQUEST_METHOD, req$PATH_INFO, "-",
    req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")

  plumber::forward()
}

#* Parses the request data as an AQP object.
#*
#* @filter aqp
function(req){
  # req$spc will be available to every endpoint down the line.
  req$spc <- jsonToAqp(req$postBody)

  plumber::forward()
}

#* Plot SPC
#*
#* @post /plot_spc
#* @png
function(req){
  plot(req$spc, name = 'designation', label = 'identifier')
}

#* Slabs
#*
#* @post /plot_slabs
#* @png
function(req){
  agg <- aqp::slab(req$spc, fm= ~ organic_carbon + ph_h2o_1 + ecec + clay + silt + sand)
  # xyplot(top ~ p.q50 | variable, data=agg, ylab='Depth',
  #        xlab='median bounded by 25th and 75th percentiles',
  #        lower=agg$p.q25, upper=agg$p.q75, ylim=c(150,-2),
  #        panel=panel.depth_function,
  #        alpha=0.25, sync.colors=TRUE,
  #        par.settings=list(superpose.line=list(col='RoyalBlue', lwd=2)),
  #        prepanel=prepanel.depth_function,
  #        cf=agg$contributing_fraction, cf.col='black', cf.interval=5,
  #        layout=c(6,1), strip=strip.custom(bg=grey(0.8)),
  #        scales=list(x=list(tick.number=4, alternating=3, relation='free')))
  plot(agg)
}

#* Pair-Wise Dissimilarity
#*
#* @post /dissimilarity
#* @png
function(req){
  d <- profile_compare(req$spc, vars=c('organic_carbon', 'ph_h2o_1', 'ecec', 'clay', 'silt', 'sand'),
                       k=0, max_d=100)
  round(d, 1)
  d.diana <- diana(d)
  par(mar=c(1,1,5,1))
  plotProfileDendrogram(req$spc, d.diana, scaling.factor = 0.8, y.offset = 10)
}

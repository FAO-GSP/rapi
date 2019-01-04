# R API for SiSINTA

#* Return a test string
#*
#* @get /test/string
function(){
  'test string'
}

#* Receive json and cast it as data.frame. For example
#*   curl --data '[{"id": 123, "name": "a thing"}, {"id": 124, "name": "another"}]' http://localhost:8000/test/json
#* generates the following data.frame
#*     id    name
#*   1 123 a thing
#*   2 124 another
#*
#* @post /test/json
function(req){
  # Transforms json to data.frame
  frame = fromJSON(req$postBody)

  print(is.data.frame(frame))
  print(frame)
}

#* Return a test png
#*
#* @get /test/plot
#* @png
function(){
  plot(1:10)
}


#* Plot SPC
#*
#* @post /test/plot_spc
#* @png
function(req){
  spc <- jsonToAqp(req$postBody)
  plot(spc, name = "designation", label = "identifier")
}

#* Slabs
#*
#* @post /test/plot_slabs
#* @png
function(req){
  spc <- jsonToAqp(req$postBody)
  agg <- aqp::slab(spc, fm= ~ organic_carbon + ph_h2o_1 + ecec + clay +silt + sand)
  xyplot(top ~ p.q50 | variable, data=agg, ylab='Depth',
         xlab='median bounded by 25th and 75th percentiles',
         lower=agg$p.q25, upper=agg$p.q75, ylim=c(150,-2),
         panel=panel.depth_function,
         alpha=0.25, sync.colors=TRUE,
         par.settings=list(superpose.line=list(col='RoyalBlue', lwd=2)),
         prepanel=prepanel.depth_function,
         cf=agg$contributing_fraction, cf.col='black', cf.interval=5,
         layout=c(6,1), strip=strip.custom(bg=grey(0.8)),
         scales=list(x=list(tick.number=4, alternating=3, relation='free')))
}

#* Pair-Wise Dissimilarity
#*
#* @post /test/dissimilarity
#* @png
function(req){
  spc <- jsonToAqp(req$postBody)
  d <- profile_compare(spc, vars=c('organic_carbon', 'ph_h2o_1', 'ecec', 'clay', 'silt', 'sand'),
                       k=0, max_d=40)
  round(d, 1)
  d.diana <- diana(d)
  par(mar=c(1,1,5,1))
  plotProfileDendrogram(spc, d.diana, scaling.factor = 0.8, y.offset = 10)
}


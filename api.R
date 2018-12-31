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
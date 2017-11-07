
# Last n words of a string

lastn<-function (str, n, sep=" ")
{
  
  v <- unlist(strsplit(str, sep))
  from <- max(1,length(v)+1-n)
  to <- length(v)
  paste(v[from:to], collapse = "_")
}


mark.sentences <- content_transformer (function(x) gsub(pattern="[.!?]", x=x, replacement = " EOS EOS EOS EOS EOS EOS "))

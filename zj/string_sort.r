library(data.table)
fread("x",header=F,sep="|")[,.(sapply(V1,function(x) paste(sort(strsplit(x," ")[[1]]),collapse=" ")))]
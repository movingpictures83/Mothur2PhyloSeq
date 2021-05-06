dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")

library(phyloseq)
library(microbiome)

input <- function(inputfile) {
  pfix = prefix()
  if (length(pfix) != 0) {
     pfix <- paste(pfix, "/", sep="")
  }
  print(pfix)
  parameters <- read.table(inputfile, as.is=T);
  rownames(parameters) <- parameters[,1]
  print(rownames(parameters))
  
  sharedfile <<- paste(pfix, toString(parameters["shared",2]), sep="")
  taxonomyfile <<- paste(pfix, toString(parameters["taxonomy",2]), sep="")
}

run <- function() {
   x <<- import_mothur(mothur_shared_file=sharedfile, mothur_constaxonomy_file=taxonomyfile)
}

output <- function(outputfile) {
   OTU1 = as(otu_table(x), "matrix")
   #if(taxa_are_rows(ps)){OTU1 <- t(OTU1)}
   # Coerce to data.frame
   OTUdf = as.data.frame(OTU1)
   write.csv(OTUdf, file=paste(outputfile, "otu_table.csv", sep="/") )

   TAX1 = as(tax_table(x), "matrix")
   TAXdf = as.data.frame(TAX1)
   write.csv(TAXdf, file=paste(outputfile, "tax_table.csv", sep="/") )
}

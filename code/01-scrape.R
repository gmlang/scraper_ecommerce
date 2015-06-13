library(cabaceo)
library(methods)
library(rvest)
library(XML)

# args = commandArgs(trailingOnly = TRUE)
# filename = args[1]

# set path
proj_path = "~/Projects/102_john"
input_path = file.path(proj_path, "input")
data_path = file.path(input_path, "listing.csv")
helper_path = file.path(proj_path, "code/helper-fn")
output_path = file.path(proj_path, "output")

# source helper functions
for (file in list.files(helper_path))
        source(file.path(helper_path, file))

# read data
dat = read.csv(data_path, header=TRUE, stringsAsFactors=FALSE)
dat = unique(dat)

# extract suppliers' names from url
suppliers = strip(dat$url, "http://www.")
suppliers = sapply(strsplit(suppliers, ".com"), function(elt) elt[1])

# retrive, parse and extract
out = lapply(1:nrow(dat), 
             function(i) {
                     Sys.sleep(2)
                     retrieve(dat$url[i], suppliers[i])
             })
output = suppressWarnings({do.call("rbind", out)})
output = cbind(dat, output)

# write.csv
filename = paste0("out_", Sys.Date(), ".csv")
write.csv(output, file=file.path(output_path, filename), row.names=F)

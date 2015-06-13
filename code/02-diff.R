# set path
proj_path = "~/Projects/102_john"
output_path = file.path(proj_path, "output")

# read data
yesterday = Sys.Date() - 1
file_today = paste0("out_", Sys.Date(), ".csv")
file_yesterday = paste0("out_", yesterday, ".csv")
dat_today = read.csv(file.path(output_path, file_today), header=T,
                     stringsAsFactors=F, na.strings="NA")
dat_yesterday = read.csv(file.path(output_path, file_yesterday), header=T,
                         stringsAsFactors=F, na.strings="NA")

# remove missings
dat_now = na.omit(dat_today)
names(dat_now) = c("url", "price_today", "status_today")
dat_pre = na.omit(dat_yesterday)
names(dat_pre) = c("url", "price_yesterday", "status_yesterday")

# merge
dat = merge(dat_now, dat_pre)

# compare prices
diff_prices = dat[with(dat, price_today != price_yesterday), ]

# compare status
diff_status = dat[with(dat, status_today != status_yesterday), ]

# combine
out = rbind(diff_prices, diff_status)

# write out
write.csv(out, file=file.path(output_path, "changes.csv"), row.names=F)

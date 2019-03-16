require("eurostat")
require("tidyr")
require("dplyr")
require("stringr")
require("MTS")
require("forecast")


source("GIS_ART_functions.R")
id <- "nrg_chdd_m"
data <- get_eurostat(id,time_format = "date",select_time = )
validcountries <- c("BE","NL","LU")

data_all <- data[,2:5]
data_all <- data_all[data_all$indic_nrg == "HDD",]
data_all$time <- as.Date(data_all$time,format= "%Y-%m-%d")
data_all <- filter(data_all, str_detect(geo, paste(validcountries, collapse="|")))
data_all_wide_spread <- spread(data_all,time,values)
ts_data <- spread(data_all,geo,values)

ts_hdd <- msts(ts_data[,3:5],seasonal.periods = 12, start = c(1975,1))

params <- det_common_order(ts_hdd)

det_max_order(params)
mod <- VARMA(ts_hdd,p = 1,q = 0)
mod$ARorder
plot(forecast(ts_hdd,36))

require("eurostat")
require("tidyr")
require("dplyr")
require("stringr")
require("MTS")


id <- "nrg_chdd_a"
data <- get_eurostat(id,time_format = "date",select_time = )
validcountries <- c("BE","NL","LU")

data_all <- data[,2:5]
data_all <- data_all[data_all$indic_nrg == "HDD",]
data_all$time <- as.Date(data_all$time,format= "%Y-%m-%d")

start_date <- as.Date("1990-01-01",format= "%Y-%m-%d")
end_date <- as.Date("2017-01-01",format= "%Y-%m-%d")

data_all <- data_all[data_all$time <= end_date,]

data_all <- filter(data_all, str_detect(geo, paste(validcountries, collapse="|")))
data_all_wide_spread <- spread(data_all,time,values)
ts_data <- spread(data_all,geo,values)

id_energy <- "nrg_cb_gas"
data_energy <- get_eurostat(id_energy,time_format = "date")
data_energy <- data_energy[data_energy$nrg_bal == "FC_OTH_HH_E",]
data_energy <- data_energy[data_energy$siec == "G3000",]
data_energy <- data_energy[data_energy$unit == "TJ_GCV",]
data_energy <- data_energy[,4:6]
data_energy <- filter(data_energy, str_detect(geo, paste(validcountries, collapse="|")))
data_energy_wide_spread <- spread(data_energy,time,values)
ts_data_energy <- spread(data_energy,geo,values)



ts_hdd <- ts(ts_data[,c(-1,-2)],start=c(1990), end=c(2017), frequency=1)
ts_energy <- ts(ts_data_energy[,c(-1,-2)],start=c(1990), end=c(2017), frequency=1)

cor(ts_data[,3],ts_data_energy[,2])
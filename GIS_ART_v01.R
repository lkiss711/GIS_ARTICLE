require("eurostat")
require("tidyr")
require("dplyr")
require("stringr")
require("MTS")
require("forecast")
require("plotly")

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

id_energy <- "nrg_cb_gas"
data_energy <- get_eurostat(id_energy,time_format = "date")
data_energy <- data_energy[data_energy$nrg_bal == "FC_OTH_HH_E",]
data_energy <- data_energy[data_energy$siec == "G3000",]
data_energy <- data_energy[data_energy$unit == "TJ_GCV",]
data_energy <- data_energy[,4:6]
data_energy <- filter(data_energy, str_detect(geo, paste(validcountries, collapse="|")))
data_energy_wide_spread <- spread(data_energy,time,values)
ts_data_energy <- spread(data_energy,geo,values)

ts_hdd <- msts(ts_data[,3:5],seasonal.periods = 12, start = c(1975,1))

dif_BE <- diff(ts_hdd[3])
dif_LU <- diff(ts_hdd[4])
dif_NL <- diff(ts_hdd[5])


params <- det_common_order(dif)

params <- det_max_order(params)

fit_BE <- arima(ts_hdd[,'BE'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))
fit_LU <- arima(ts_hdd[,'LU'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))
fit_NL <- arima(ts_hdd[,'NL'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))

pred_BE <- predict(fit_BE,36)
pred_LU <- predict(fit_LU,36)
pred_NL <- predict(fit_NL,36)



pred_dates <- as.data.frame(seq(from = as.Date("2019-01-01"), to = as.Date("2021-12-01"), by = 'month'))
pred_values <- as.data.frame(cbind(pred_BE$pred,pred_LU$pred,pred_NL$pred))
pred_df <- cbind(pred_dates,pred_values)
colnames(pred_df) <- colnames(ts_data[,2:5])
prediction_df <- rbind(ts_data[,2:5],pred_df)


run_plot_raw_data <- parse("GIS_ART_plot.R")
eval(run_plot_raw_data)
run_plot_trend <- parse("GIS_ART_plot_trend.R")
eval(run_plot_trend)





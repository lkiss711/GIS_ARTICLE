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

decomp_ts_hdd <- decompose(ts_hdd)

dif_BE <- diff(ts_hdd[3])
dif_LU <- diff(ts_hdd[4])
dif_NL <- diff(ts_hdd[5])


params <- det_common_order(ts_data[493:528,3:5])

params <- det_max_order(params)

fit_BE <- arima(ts_hdd[,'BE'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))
fit_LU <- arima(ts_hdd[,'LU'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))
fit_NL <- arima(ts_hdd[,'NL'],order = c(1,0,0),seasonal = list(order = c(1,1,0),period = 12))

pred_BE <- predict(fit_BE,36)
pred_LU <- predict(fit_LU,36)
pred_NL <- predict(fit_NL,36)

View(pred_BE$pred)

pred_dates <- as.data.frame(seq(from = as.Date("2019-01-01"), to = as.Date("2021-12-01"), by = 'month'))
pred_values <- as.data.frame(cbind(pred_BE$pred,pred_LU$pred,pred_NL$pred))
pred_df <- cbind(pred_dates,pred_values)
colnames(pred_df) <- colnames(ts_data[,2:5])
prediction_df <- rbind(ts_data[,2:5],pred_df)


run_plot_raw_data <- parse("GIS_ART_plot.R")
eval(run_plot_raw_data)
run_plot_trend <- parse("GIS_ART_plot_trend.R")
eval(run_plot_trend)
run_plot_pred <- parse("GIS_ART_plot_pred.R")
eval(run_plot_pred)

View(ts_data[1:492,3:5])


View(params)
# mod00 <- sVARMA(ts_data[1:492,3:5], order = c(1,0,1),sorder = c(1,0,1),s = 12,switch = T)
mod00 <- VARMA(ts_data[1:492,3:5], p = 1, q = 1)
# pred00 <- sVARMApred(mod00,orig = 492, h = 36)

VARMApred(mod00,h = 36)
View(pred00$pred)

View(ts_data[493:528,3:5])

id_energy <- "nrg_cb_gas"
data_energy <- get_eurostat(id_energy,time_format = "date")
data_energy <- data_energy[data_energy$nrg_bal == "FC_OTH_HH_E",]
data_energy <- data_energy[data_energy$siec == "G3000",]
data_energy <- data_energy[data_energy$unit == "TJ_GCV",]
data_energy <- data_energy[,4:6]
data_energy <- filter(data_energy, str_detect(geo, paste(validcountries, collapse="|")))
data_energy_wide_spread <- spread(data_energy,time,values)
ts_data_energy <- spread(data_energy,geo,values)
ts_data_energy <- cbind(ts_data_energy,(ts_hdd[c(181,193,205,217,229,241,253,265,277,289,301,313,325,337,349,361,373,385,397,409,421,433,445,457,469,481,493,505),1]))
colnames(ts_data_energy) <- c("time","BE","NL","LU","BE_en")


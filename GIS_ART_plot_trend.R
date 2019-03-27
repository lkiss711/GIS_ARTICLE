library("plotly")

Sys.setenv("plotly_username"="lkiss711")
Sys.setenv("plotly_api_key"="f60zhortDCQyEM80zPNA")


trend_df <- cbind(ts_data[7:522,2],decomp_ts_hdd$trend[7:522,])
colnames(trend_df) = c('time','BE','LU','NL')

p_trend <- plot_ly(data = trend_df,x = ~time) 

p_trend <- add_lines(p_trend, y = ~BE,name = 'Belgium',line = list(width = 1, color = "#00587b"),visible = T) 
p_trend <- add_lines(p_trend,y = ~LU, name = 'Luxembourg',line = list(width = 1, color = "#DBA901"),visible = F) 
p_trend <- add_lines(p_trend,y = ~NL, name = 'Netherland',line = list(width = 1, color = "##FE2E64"),visible = F)

p_trend
p_trend <- 
  (p_trend %>% 
     layout(
       updatemenus = list(
         list(yanchor = 'auto',buttons =list(
           list(method = "restyle",args = list("visible", list(T,F,F)),label = 'Belgium'),
           list(method = "restyle",args = list("visible", list(F,T,F)),label = 'Luxembourg'),
           list(method = "restyle",args = list("visible", list(F,F,T)),label = 'Netherland')
         )))))
p_trend

# api_create(p_trend, filename = "benelux_hdd_trend")
# https://plot.ly/~lkiss711/31/

p_gas <- plot_ly(data = ts_data_energy,x = ~time) 
p_gas <- add_lines(p_gas, y = ~BE,name = 'Belgium',line = list(width = 1, color = "#00587b"),visible = T)
p_gas <- add_lines(p_gas, y = ~BE_en,name = 'Belgium Energy',line = list(width = 1, color = "##FE2E64"),visible = T) 
p_gas


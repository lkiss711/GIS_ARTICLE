library("plotly")

Sys.setenv("plotly_username"="lkiss711")
Sys.setenv("plotly_api_key"="f60zhortDCQyEM80zPNA")



p_fcast <- plot_ly(data = prediction_df[529:564,],x = ~time) 

p_fcast <- add_lines(p_fcast, y = ~BE,name = 'Belgium',line = list(width = 1, color = "#00587b"),visible = T) 
p_fcast <- add_lines(p_fcast,y = ~LU, name = 'Luxembourg',line = list(width = 1, color = "#DBA901"),visible = F) 
p_fcast <- add_lines(p_fcast,y = ~NL, name = 'Netherland',line = list(width = 1, color = "##FE2E64"),visible = F)



p_fcast <- 
  (p_fcast %>% 
     layout(
       updatemenus = list(
         list(yanchor = 'auto',buttons =list(
           list(method = "restyle",args = list("visible", list(T,F,F)),label = 'Belgium'),
           list(method = "restyle",args = list("visible", list(F,T,F)),label = 'Luxembourg'),
           list(method = "restyle",args = list("visible", list(F,F,T)),label = 'Netherland')
         )))))
p_fcast

# api_create(p_fcast, filename = "benelux_hdd_forecast")
# https://plot.ly/~lkiss711/29/#/



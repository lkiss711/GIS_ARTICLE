library("plotly")


p_fcast <- plot_ly(data = prediction_df,x = ~time) 

p_fcast <- add_lines(p_fcast, y = ~BE,name = 'Belgium',line = list(width = 1, color = "#00587b"),visible = T) 
p_fcast <- add_lines(p_fcast,y = ~LU, name = 'Luxembourg',line = list(width = 1, color = "#DBA901"),visible = T) 
p_fcast <- add_lines(p_fcast,y = ~NL, name = 'Netherland',line = list(width = 1, color = "##FE2E64"),visible = T)

p_fcast
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



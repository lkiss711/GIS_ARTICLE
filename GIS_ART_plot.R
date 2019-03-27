library("plotly")

Sys.setenv("plotly_username"="lkiss711")
Sys.setenv("plotly_api_key"="f60zhortDCQyEM80zPNA")


p <- plot_ly(data = ts_data,x = ~time) 

p <- add_lines(p, y = ~BE,name = 'Belgium',line = list(width = 1, color = "#00587b"),visible = T) 
p <- add_lines(p,y = ~LU, name = 'Luxembourg',line = list(width = 1, color = "#DBA901"),visible = T) 
p <- add_lines(p,y = ~NL, name = 'Netherland',line = list(width = 1, color = "##FE2E64"),visible = T)

p <- 
  (p %>% 
     layout(
       updatemenus = list(
         list(yanchor = 'auto',buttons =list(
           list(method = "restyle",args = list("visible", list(T,F,F)),label = 'Belgium'),
           list(method = "restyle",args = list("visible", list(F,T,F)),label = 'Luxembourg'),
           list(method = "restyle",args = list("visible", list(F,F,T)),label = 'Netherland')
         )))))
p

# api_create(p, filename = "benelux_hdd_data")
# https://plot.ly/~lkiss711/33/#/ 
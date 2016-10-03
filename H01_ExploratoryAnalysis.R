pkgs <- c('data.table',
          'ggplot2',
          'ggthemes',
          'plotly',
          'stringr',
          'tidyr',
          'dplyr',
          'reshape2')
lapply(pkgs, require, character.only = TRUE)

dir <- '/media/adam/HDD/Data/Kaggle/Housesalesprediction/kc_house_data.csv'
houses.dt <- fread(dir)

## Data cleaning

houses.dt$date <- gsub('T\\d{6}', '', houses.dt$date,)
houses.dt$date <- as.Date(houses.dt$date, "%Y%m%d")

top10.dt <- as.data.frame(head(houses.dt[order(houses.dt$price,decreasing=T),],.1*nrow(houses.dt)))
bot10.dt <- as.data.frame(head(houses.dt[order(houses.dt$price,decreasing=F),],.1*nrow(houses.dt)))

keepCols <- c("date", "price", "bedrooms", "bathrooms", "sqft_living", "condition", "grade", "yr_built")
top10.dt <- top10.dt[, which(names(top10.dt) %in% keepCols)]
bot10.dt <- bot10.dt[, which(names(bot10.dt) %in% keepCols)]
bot10.dt <- bot10.dt[order(bot10.dt$date),]
top10.dt <- top10.dt[order(top10.dt$date),]


top10.dt <- mutate(top10.dt, meanDevPrice = 1-(price - mean(price))/mean(price))
bot10.dt <- mutate(bot10.dt, meanDevPrice = 1-(price - mean(price))/mean(price))

dailyTop.dt <- top10.dt %>%
  group_by(date) %>%
  summarise(dayPrice = mean(meanDevPrice),
            count = n())

dailyBot.dt <- bot10.dt %>%
  group_by(date) %>%
  summarise(dayPrice = mean(meanDevPrice),
            count = n())


pal <- RColorBrewer::brewer.pal(nlevels(dailyBot.dt$count), "Set1")
plot_ly(data = dailyTop.dt, x = date, y = dayPrice, 
        mode = "markers", size = count, opacity = 0.8, name = "Top 10%") %>%
  add_trace(data = dailyBot.dt, x = date, y = dayPrice, 
            mode = "markers", size = count, opacity = 0.8, name = "Bottom 10%") %>%
  layout(title = "Daily Price Fluctuations in King County Housing Market",
           xaxis = list(title ="Date"),
           yaxis = list(title ="Price Deviation from Group Mean"))















